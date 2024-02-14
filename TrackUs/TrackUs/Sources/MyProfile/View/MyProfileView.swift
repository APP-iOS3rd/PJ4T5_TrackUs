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
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @State private var selectedImage: Image?
    @State private var isShownFullScreenCover: Bool = false
    
    var body: some View {
        VStack {
            ScrollView{
                // MARK: - 프로필 헤더
                VStack {
                    if let image = authViewModel.userInfo.image{
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 116, height: 116)
                            .padding(.vertical, 12)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }else {
                        Image(.profileDefault)
                            .resizable()
                            .frame(width: 116, height: 116)
                            .padding(.vertical, 12)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        router.push(.profileEdit)
                    }) {
                        HStack(spacing: 6) {
                            Text("\(authViewModel.userInfo.username)님")
                                .customFontStyle(.gray1_SB16)
                            Image(.chevronRight)
                        }
                    }
                    
                    HStack {
                        if let height = authViewModel.userInfo.height, let weight = authViewModel.userInfo.weight, let age = authViewModel.userInfo.age {
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
                    Button(action: {
                        router.push(.runningRecorded)
                    }) {
                        MenuItem(title: "러닝기록", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                // MARK: - 서비스
                MenuItems {
                    Text("서비스")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    Button(action: {
                        router.present(sheet: .webView(url: Constants.WebViewUrl.TERMS_OF_SERVICE_URL))
                    }) {
                        MenuItem(title: "이용약관", image: .init(.chevronRight))
                    }
                    Button(action: {
                        router.present(sheet: .webView(url: Constants.WebViewUrl.OPEN_SOURCE_LICENSE_URL))
                    }) {
                        MenuItem(title: "오픈소스/라이센스", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                // MARK: - 고객지원
                MenuItems {
                    Text("고객지원")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    Button(action: {
                        router.push(.faq)
                    }) {
                        MenuItem(title: "자주묻는 질문 Q&A", image: .init(.chevronRight))
                    }
                    Button(action: {
                        router.present(sheet: .webView(url: Constants.WebViewUrl.SERVICE_REQUEST_URL))
                    }) {
                        MenuItem(title: "문의하기", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                // MARK: - 프리미엄 결제
                MenuItems {
                    HStack(spacing: 6) {
                        Text("트랙어스 응원하기")
                            .customFontStyle(.gray1_SB16)
                        Image(.star)
                    }
                } content: {
                    Button {
                        router.present(fullScreenCover: .payment)
                    } label: {
                        MenuItem(title: "프리미엄 결제하기", image: .init(.chevronRight))
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .customNavigation {
            NavigationText(title: "마이페이지")
        } right: {
            Button(action: {
                router.push(.setting)
            }) {
                Image(.settingLogo)
                    .foregroundColor(Color.gray1)
            }
        }
        .onAppear {
            //authViewModel.getMyInformation()
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
