//
//  UserReportView.swift
//  TrackUs
//
//  Created by 박선구 on 3/19/24.
//

import SwiftUI

enum reportReason: String, CaseIterable, Identifiable {
    case reason0 = "커뮤니티 위반사례"
    case reason1 = "욕설, 비방, 혐오표현을 해요"
    case reason2 = "연애 목적의 대화를 시도해요"
    case reason3 = "불쾌감을 주는 이름을 사용해요"
    case reason4 = "갈등 조장 및 허위 사실을 유포해요"
    case reason5 = "채팅방 도배 및 광고를 해요"
    case reason6 = "다른 문제가 있어요"
    
    var id: Self { self }
}

struct UserReportView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var userProfileViewModel = UserProfileViewModel.shared
    
    @State private var image: Image?
    
    let userUid: String
    
    init(userUid: String) {
        self.userUid = userUid
    }
    
    var body: some View {
        VStack {
            userReportContent(userProfileViewModel: userProfileViewModel, userInfo: userProfileViewModel.otherUserInfo)
        }
        .onAppear {
            userProfileViewModel.getOtherUserInfo(for: userUid)
            userProfileViewModel.fetchUserLog(userId: userUid) {
                print(userProfileViewModel.runningLog)
            }
        }
        .customNavigation {
            NavigationText(title: "신고하기")
        } left: {
            NavigationBackButton()
        }
    }
}

struct userReportContent: View {
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @EnvironmentObject var router: Router
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var selectedReason : reportReason = .reason0
    
    @State private var reportText : String = "" // 신고내용
    
    @FocusState var isInputActive: Bool
    @State private var pickerPresented: Bool = false
    @State private var isReport: Bool = false
    @State private var successReport: Bool = false
    
    let userInfo: UserInfo
    
    var body: some View {
        VStack {
            //                ScrollView {
            HStack {
                Text("신고 대상")
                    .customFontStyle(.gray1_SB15)
                
                Spacer()
            }
            
            VStack {
                // 사용자 이미지
                if let image = userInfo.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 116, height: 116)
                        .padding(.vertical, 12)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                } else {
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 116, height: 116)
                        .padding(.vertical, 12)
                        .clipShape(Circle())
                }
                
                // 사용자 닉네임
                Text("\(userInfo.username)님")
                    .customFontStyle(.gray1_B16)
            }
            
            VStack(alignment: .center) {
                HStack {
                    Text("신고 사유")
                        .customFontStyle(.gray1_SB15)
                    
                    Spacer()
                }
                // 커뮤니티 위반사례 피커
                Button {
                    pickerPresented.toggle()
                } label: {
                    HStack {
                        Text(selectedReason.rawValue)
                            .customFontStyle(selectedReason == .reason0 ? .gray2_R16 : .gray1_R16)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .resizable()
                            .frame(width: 9, height: 15)
                            .foregroundColor(.gray1)
                    }
                    .padding()
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray1)
                }
                
            }
            .padding(.bottom, 20)
            
            VStack {
                HStack {
                    Text("신고 내용")
                        .customFontStyle(.gray1_SB15)
                    
                    Spacer()
                }
                // 텍스트 필드
                ZStack(alignment: .topLeading){
                    TextEditor(text: $reportText)
                        .customFontStyle(.gray1_R16)
                        .autocorrectionDisabled()
                        .focused($isInputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button {
                                    isInputActive = false
                                } label: {
                                    Text("확인")
                                        .foregroundColor(.gray1)
                                }
                            }
                        }
                        .frame(height: 114)
                        .padding(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray1, lineWidth: 1)
                        )
                    if reportText.isEmpty{
                        Text("신고 사유에 대한 내용을 자세히 입력해주세요.")
                            .padding()
                            .customFontStyle(.gray2_R16)
                    }
                    
                }
            }
            
            HStack {
                Text("허위 신고 적발시 허위 신고 유저에게 불이익이 발생할 수 있습니다.")
                    .customFontStyle(.gray2_R12)
                
                Spacer()
            }
            .padding(.top, 8)
            
            Spacer()
            
            Button {
                isReport.toggle()
            } label: {
                Text("신고하기")
                    .customFontStyle(.white_B16)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(reportText.isEmpty || selectedReason == .reason0 ? .gray3 : .caution)
                    .cornerRadius(50)
            }
            .disabled(reportText.isEmpty || selectedReason == .reason0)
        }
        .onTapGesture {
            isInputActive = false
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $pickerPresented, content: {
            reportPicker(selectedReason: $selectedReason, pickerPresented: $pickerPresented)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.hidden)
        })
        .alert("\(userInfo.username)님", isPresented: $isReport) {
            Button("신고", role: .destructive) {
                successReport.toggle()
                // 파베에 올리는 부분
                
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("신고 하시겠습니까?")
        }
        .alert("신고가 완료되었습니다.", isPresented: $successReport) {
            Button("확인") {
                router.pop()
            }
        } message: {
            Text("")
        }
    }
}

struct reportPicker: View {
    @Binding var selectedReason: reportReason
    @Binding var pickerPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    pickerPresented.toggle()
                } label: {
                    Text("확인")
                        .customFontStyle(.main_SB16)
                        .padding(25)
                }
            }
            
            Picker("", selection: $selectedReason) {
                ForEach(reportReason.allCases, id: \.self) { reason in
                    Text(reason.rawValue)
                        .font(.system(size: 16))
                        .tag(reason)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal, 50)
        }
    }
}

//#Preview {
//    UserReportView()
//}
