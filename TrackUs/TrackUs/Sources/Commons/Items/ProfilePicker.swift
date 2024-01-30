//
//  ProfilePicker.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI
import PhotosUI

struct ProfilePicker: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @Binding var image: Image?
    let size: CGFloat = 160
    
//    /// 사이즈 조절 필요한 경우 (회원가입 이외) - size = 프레임 사이즈(지름)  image:  Binding<Image?>
//    init(size: CGFloat, image: Binding<Image?>) {
//        self.size = size
//        self.selectedPhoto = nil
//        self.image = image
//    }
//    
//    /// 기본 프로필 이미지 피커 - image:  Binding<Image?>
//    init(image: Image?) {
//        self.size = 160
//        self.selectedPhoto = nil
//        self.image = image
//    }
    
    
    var body: some View {
        PhotosPicker(selection: $selectedPhoto,
                     matching: .images,
                     photoLibrary: .shared()) {
            if let image = self.image {
                ZStack{
                    image
                        .resizable()
                        .frame(width: size, height: size)
                        .scaledToFill()
                        .clipShape(Circle())
                    Button(action: {
                        self.image = nil
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    })
                    .overlay(
                        Circle()
                            .stroke( .white, lineWidth: 2)
                    )
                    .offset(x: 56, y: 56)
                }
                
            }else{
                ZStack{
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: size, height: size)
                        .scaledToFit()
                        .clipShape(Circle())
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .symbolRenderingMode(.multicolor)
                        .symbolVariant(.none)
                    // 회색 지정 후 추가 수정
                        .foregroundColor(.gray)
                        .overlay(
                            Circle()
                                .stroke( .white, lineWidth: 2)
                        )
                        .offset(x: 56, y: 56)
                }
            }
        }
        // 비동기 처리 - 이미지 로딩때문에 다른 부분 실행 안되는 부분 방지
                     .task(id: selectedPhoto) {
                         image = try? await selectedPhoto?.loadTransferable(type: Image.self)
                     }
                     .animation(.easeInOut, value: image)
                     .padding(.top, 40)
    }
}

//#Preview {
//    ProfilePicker()
//}
