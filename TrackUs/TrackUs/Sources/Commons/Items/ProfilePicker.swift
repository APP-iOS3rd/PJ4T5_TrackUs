//
//  ProfilePicker.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI
import PhotosUI

struct ProfilePicker: View {
    @State private var showingConfirmationDialog: Bool = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showPicker = false
    @Binding private var UIimage: UIImage?
    private let size: CGFloat
    
    // MARK: - 프로필 Picker(기본)
    // 사용 예시
    // ProfilePicker(image: $바인딩 이미지 변수<Image?> )
    
    /// 프로필 Picker(기본) - image:  Binding<Image?>
    init(UIimage: Binding<UIImage?>) {
        self.size = 160
        self._UIimage = UIimage
    }
    
    // MARK: - 프로필 선택 피커(사이즈 변경)
    // 사용 예시
    // ProfilePicker(image: $바인딩 이미지 변수(Image?), size: 지름 크기)
    
    /// 프로필 선택 피커(사이즈 변경) - size = 프레임 사이즈(지름)  image:  Binding<Image?>
    init(UIimage: Binding<UIImage?>, size: CGFloat) {
        self.size = size
        self._UIimage = UIimage
    }
    
    var body: some View {
        Button {
            showingConfirmationDialog.toggle()
        } label: {
            ZStack{
                if let UIimage = self.UIimage {
                    Image(uiImage: UIimage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                }else{
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: size, height: size)
                        //.scaledToFit()
                        .clipShape(Circle())
                }
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 32*size/160, height: 32*size/160)
                    .symbolRenderingMode(.multicolor)
                    .symbolVariant(.none)
                    .foregroundColor(.gray2)
                    .overlay(
                        Circle()
                            .stroke( .white, lineWidth: 2*size/160)
                    )
                    .offset(x: 56*size/160, y: 56*size/160)
            }
        }.confirmationDialog(Text("프로필 사진 설정"),
                             isPresented: $showingConfirmationDialog,
                             titleVisibility: .automatic) {
            Button {
                showPicker.toggle()
            } label: {
                Text("앨범에서 사진 선택")
            }
            if UIimage != nil {
                Button("기본 이미지 설정", role: .destructive) {
                    self.UIimage = nil
                    self.selectedPhoto = nil
                }
            }
        }
                             .photosPicker(isPresented: $showPicker, selection: $selectedPhoto)
                             .task(id: selectedPhoto) {
                                 if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                                     self.UIimage = UIImage(data: data)
                                 }
                             }
    }
}
