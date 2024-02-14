//
//  MyRunningRecordView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

enum RecordFilter: String, CaseIterable, Identifiable { // 나이대 피커
    case all = "전체"
    case personal = "개인"
    case mate = "러닝메이트"
    
    var id: Self { self }
}

struct MyRecordView: View {
    @EnvironmentObject var router: Router
    var vGridItems = [GridItem()]
    @State var filterSelect : RecordFilter = .all
    @State private var calendarButton = false
    @State private var selectedFilter: RecordFilter?
    @State private var gridDelete = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Button {
                        router.present(fullScreenCover: .payment)
                    } label: {
                        HStack {
                            Image(.iconTrackUsPro2)
                            VStack(alignment: .leading) {
                                Text("TrackUs Pro")
                                    .customFontStyle(.main_SB14)
                                Text("상세한 러닝 리포트를 통해 효율적인 러닝을 즐겨보세요")
                                    .customFontStyle(.gray4_M12)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray1)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.gray3)
                        )
                    }
                    
                    VStack(alignment: .leading) {
                        Text("러닝 기록")
                            .customFontStyle(.gray1_B24)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        Text("러닝 기록과 상세 러닝 정보를 확인해보세요.")
                            .customFontStyle(.gray2_R15)
                            .padding(.bottom, 20)
                    }
                    
                    HStack {
                        Menu {
                            ForEach(RecordFilter.allCases) { filter in
                                Button {
                                    selectedFilter = filter
                                } label: {
                                    Text(filter.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedFilter?.rawValue ?? "전체")
                                    .customFontStyle(.gray1_SB12)
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(.gray1)
                            }
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.gray1)
                            )
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            calendarButton.toggle()
                        } label: {
                            Image("Calendar")
                        }
                    }
                    
                    // RecordCell
                    LazyVGrid(columns: vGridItems, spacing: 0) {
                        ForEach(0...6, id: \.self) { item in
                            RecordCell(gridDelete: $gridDelete)
                            Divider()
                                .padding(.top, 24)
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom, 10)
                .padding(.horizontal, 16)
            }
        }
        .popup(isPresented: $gridDelete) {
            HStack {
                Image(.trashSlash)
                
                Spacer()
                
                Text("러닝 기록이 삭제되었습니다.")
                    .customFontStyle(.gray1_SB16)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.gray3)
            )
            .clipShape(Capsule())
            .padding(45)
            .shadow(radius: 5)
            .offset(y: 30)
            
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.smooth)
                .autohideIn(2)
        }
    }
}

struct RecordCell: View {
    @State private var isDelete = false
    @Binding var gridDelete : Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 10) {
                Image(.mapPath)
                    .resizable()
                //                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                //                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("개인")
                            .foregroundColor(.white)
                            .font(.system(size: 11))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(Color.main)
                            .cornerRadius(25)
                        
                        Spacer()
                        
                        Menu {
                            Button(role: .destructive ,action: {
                                self.isDelete = true
                            }) {
                                Text("러닝기록 삭제")
                            }
                            
                            Button {
                                
                            } label: {
                                Text("취소")
                            }
                            .foregroundColor(.gray1)
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .frame(width: 20, height: 20)
                        }
                        .foregroundColor(.gray1)
                    }
                    
                    Text("광명시 러닝 메이트 구합니다")
                        .customFontStyle(.gray1_B16)
                    
                    HStack {
                        HStack {
                            Image(.pin)
                            Text("서울숲카페거리")
                                .customFontStyle(.gray1_R12)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(.timerLine)
                            Text("10:02 AM")
                                .customFontStyle(.gray1_R12)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(.arrowBoth)
                            Text("1.72km")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .resizable()
                                .frame(width: 15, height: 12)
                                .foregroundColor(.gray1)
                            
                            Text("3/6")
                                .customFontStyle(.gray1_M16)
                        }
                        
                        Spacer()
                        
                        Text("2024년 2월 12일")
                            .customFontStyle(.gray1_SB12)
                    }
                }
            }
            
        }
        .padding(.top, 24)
        .alert("알림", isPresented: $isDelete) {
            Button("삭제", role: .destructive) {
                gridDelete = true
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("러닝 기록을 삭제하시겠습니까? \n 삭제한 러닝기록은 복구할 수 없습니다.")
        }
    }
}

#Preview {
    MyRecordView()
//    RecordCell()
}
