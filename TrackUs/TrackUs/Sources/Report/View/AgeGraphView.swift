//
//  AgeGraphView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

enum AvgAge: String, CaseIterable, Identifiable { // 나이대 피커
    case teens = "10대"
    case twenties = "20대"
    case thirties = "30대"
    case forties = "40대"
    case fifties = "50대"
    
    var id: Self { self }
}

//MARK: - 연령대 추세 비교 가로 그래프, 바 그래프

struct AgeGraphView: View {
    var selectedTab: CircleTab
    @State private var isPickerPresented = false
    @State var selectedAge : AvgAge = .twenties
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack {
            HStack {
                Text("\(selectedTab == .day ? formattedDate : formattedMonth) 운동량")
                    .customFontStyle(.gray1_SB16)
                
                Spacer()
                
                Button {
                    isPickerPresented.toggle()
                } label: {
                    HStack {
                        Text(selectedAge.rawValue)
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
            }
            
            HStack(spacing: 3) {
                Text("동일 연령대의 TrackUs 회원 중").customFontStyle(.gray2_R12)
                Text("상위").customFontStyle(.gray2_R12)
                Text("\(33.2, specifier: "%.1f")%").customFontStyle(.gray1_R12).bold()
                Text("(운동량 기준)").customFontStyle(.gray2_R12)
                
                Spacer()
            }
            
            // 가로 그래프
            HorizontalGraph(selectedAge: $selectedAge)
                .padding(.top, 14)
                .padding(.bottom, 40)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("평균 운동량 추세")
                        .customFontStyle(.gray1_SB16)
                        .padding(.bottom, 5)
                    Text("그래프를 터치하여 월별 피드백을 확인해보세요.")
                        .customFontStyle(.gray2_R12)
                }
                
                Spacer()
            }
            
            if selectedTab == .day {
                WeakGraphView(selectedAge: $selectedAge)
                    .padding(.top, 14)
                    .padding(.bottom, 40)
            } else {
                BarGraphView(selectedAge: $selectedAge)
                    .padding(.top, 14)
                    .padding(.bottom, 40)
            }
            
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $isPickerPresented,onDismiss: {
            
        }, content: {
            filterPicker(selectedAge: $selectedAge, isPickerPresented: $isPickerPresented)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.hidden)
        })
    }
    
    var formattedDate: String {
            guard let selectedDate = selectedDate else {
                return ""
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일" // 이 부분을 원하는 형식으로 수정
            return dateFormatter.string(from: selectedDate)
        }
    
    var formattedMonth: String {
            guard let selectedDate = selectedDate else {
                return ""
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = " M월" // 이 부분을 원하는 형식으로 수정
            return dateFormatter.string(from: selectedDate)
        }
}

struct filterPicker: View {
    @Binding var selectedAge: AvgAge
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    isPickerPresented.toggle()
                }, label: {
                    Text("확인")
                        .customFontStyle(.main_SB16)
                        .padding(25)
                })
            }
            
            
            Picker("", selection: $selectedAge) {
                ForEach(AvgAge.allCases, id: \.self) { age in
                    Text(age.rawValue).tag(age)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal, 50)
            
        }
    }
}

//#Preview {
//    AgeGraphView(selectedTab: .day)
//}
