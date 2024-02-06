//

//
//  MyProfileView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI
import Combine

struct MyProfileView: View {
    @StateObject var viewModel = UserInfoViewModel()
    @State private var selectedImage: Image?
    @State private var isShownFullScreenCover: Bool = false
    
    var body: some View {
        VStack {
            ScrollView{
                // MARK: - 프로필 헤더
                VStack {
                    if let profileImageUrl = viewModel.userInfo.profileImageUrl {
                        FirebaseProfileImageView(imageURL: profileImageUrl)
                            .frame(width: 116, height: 116)
                            .padding(.vertical, 12)
                            .clipShape(Circle())
                    } else {
                        Image(.profileDefault)
                            .resizable()
                            .frame(width: 116, height: 116)
                            .padding(.vertical, 12)
                            .clipShape(Circle())
                    }
                    
                    NavigationLink(value: "ProfileEditView") {
                        HStack(spacing: 6) {
                            Text("\(viewModel.userInfo.username)님")
                                .customFontStyle(.gray1_SB16)
                            Image(.chevronRight)
                        }
                    }
                    
                    HStack {
                        if let height = viewModel.userInfo.height, let weight = viewModel.userInfo.weight, let age = viewModel.userInfo.age {
                                    Text("\(height)cm · \(weight)kg · \(age)대")
                                        .customFontStyle(.gray2_R16)
                                } else {
                                    Text("신체 정보를 입력하세요")
                                        .customFontStyle(.gray2_R16)
                                }
                            }
                        }
                .padding(.bottom, 32)
                
                // MARK: - 리스트
                MenuItems {
                    Text("운동")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    NavigationLink(value: "RunningRecordView") {
                        MenuItem(title: "러닝기록", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems {
                    Text("서비스")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    NavigationLink(value: "TermsOfService") {
                        MenuItem(title: "이용약관", image: .init(.chevronRight))
                    }
                    
                    NavigationLink(value: "OpenSourceLicense") {
                        MenuItem(title: "오픈소스/라이센스", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems {
                    Text("고객지원")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    NavigationLink(value: "FAQView") {
                        MenuItem(title: "자주묻는 질문 Q&A", image: .init(.chevronRight))
                    }
                    NavigationLink(value: "ServiceRequest") {
                        MenuItem(title: "문의하기", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems {
                    HStack(spacing: 6) {
                        Text("트랙어스 응원하기")
                            .customFontStyle(.gray1_SB16)
                        Image(.star)
                    }
                } content: {
                    Button {
                        viewModel.getMyInformation()
                        isShownFullScreenCover.toggle()
                    } label: {
                        MenuItem(title: "프리미엄 결제하기", image: .init(.chevronRight))
                    }
                    .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                        PremiumPaymentView(isShownFullScreenCover: $isShownFullScreenCover)
                    })
                }
                .padding(.bottom, 60)
            }
        }
        .customNavigation {
            NavigationText(title: "마이페이지")
        } right: {
            NavigationLink(value: "SettingsView") {
                Image(.settingLogo)
                    .foregroundColor(Color.gray1)
            }
        }
        .onAppear {
            viewModel.getMyInformation()
        }
    }
}

struct FirebaseProfileImageView: View {
    @StateObject var imageLoader: ImageLoader
    let imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
        _imageLoader = StateObject(wrappedValue: ImageLoader(imageURL: imageURL))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 116, height: 116)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .shadow(radius: 2)
        } else {
            ProgressView()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let imageURL: String
    
    private var cancellable: AnyCancellable?
    
    init(imageURL: String) {
        self.imageURL = imageURL
        loadImage()
    }
    
    private func loadImage() {
        guard let url = URL(string: imageURL) else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

//
//#Preview {
//    MyProfileView()
//}
