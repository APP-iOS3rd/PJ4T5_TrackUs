//
//  ProfilePicker.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI
import PhotosUI

struct ProfilePicker: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @Binding private var image: Image?
    private let size: CGFloat
    
    // MARK: - 프로필 Picker(기본)
    // 사용 예시
    // ProfilePicker(image: $바인딩 이미지 변수<Image?> )
    
    /// 프로필 Picker(기본) - image:  Binding<Image?>
    init(image: Binding<Image?>) {
        self.size = 160
        self._image = image
    }
    
    // MARK: - 프로필 선택 피커(사이즈 변경)
    // 사용 예시
    // ProfilePicker(image: $바인딩 이미지 변수(Image?), size: 지름 크기)
    
    /// 프로필 선택 피커(사이즈 변경) - size = 프레임 사이즈(지름)  image:  Binding<Image?>
    init(image: Binding<Image?>, size: CGFloat) {
        self.size = size
        self._image = image
    }
    
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
                
                
            } else {
                ZStack{
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: size, height: size)
                        .scaledToFit()
                        .clipShape(Circle())
                    Image(.camera)
                        .symbolRenderingMode(.multicolor)
                        .symbolVariant(.none)
                    // 회색 지정 후 추가 수정
                        .foregroundColor(.gray2)
                        .overlay(
                            Circle()
                                .stroke( .white, lineWidth: 2)
                        )
                        .offset(x: size / 3, y: size / 3)
                }
            }
        }
        // 비동기 처리 - 이미지 로딩때문에 다른 부분 실행 안되는 부분 방지
                     .task(id: selectedPhoto) {
                         image = try? await selectedPhoto?.loadTransferable(type: Image.self)
                     }
                     .animation(.easeInOut, value: image)
    }
}
