//
//  CustomButton.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import SwiftUI

// SelectPicker, PickerSheet 한 세트로 사용

/* 전체 코드 간단 예시
 struct ContentView: View {
     @State var text: String = ""
     @State var value: Double?
     @State var check: Bool = false
     @State private var pickercheck: Bool = false
     
     var body: some View {
         VStack {
             SelectPicker(selectedValueBinding: $value, showingSheet: $pickercheck, title: "체중", unit: "kg")
         }
         .padding()
         .overlay(alignment: .center) {
             if pickercheck {
                 PickerSheet(selectedValueBinding: $value, check: $pickercheck, title: "체중", unit: "kg", rangeFrom: 20, rangeThrough: 150, rangeBy: 1, selectedValue: 70)
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .background(!pickercheck ? Color.white : Color.black.opacity(0.45))
                     .edgesIgnoringSafeArea(.all)
             }
         }
         .animation(.easeOut(duration: 0.5), value: pickercheck)
     }
 }
 */

enum PickerType {
    case height
    case weight
    case age
    case dailyGoal
}

struct PickerTypeInfo {
    var title: String
    var unit: String
    var format: String
    var rangeValues: [Double]
    var startingValue: Double
    
    init(pickerType: PickerType) {
        switch pickerType {
        case .height:
            self.title = "키"
            self.unit = "cm"
            self.format = "%.0f"
            self.rangeValues = stride(from: 100, through: 250, by: 1).map { $0 }
            self.startingValue = 160
        case .weight:
            self.title = "체중"
            self.unit = "kg"
            self.format = "%.0f"
            self.rangeValues = stride(from: 30, through: 200, by: 1).map { $0 }
            self.startingValue = 60
        case .age:
            self.title = "나이대"
            self.unit = "대"
            self.format = "%.0f"
            self.rangeValues = stride(from: 10, through: 60, by: 10).map { $0 }
            self.startingValue = 30
        case .dailyGoal:
            self.title = "일일 운동량"
            self.unit = "km"
            self.format = "%.1f"
            self.rangeValues = stride(from: 0, through: 40, by: 0.1).map { $0 }
            self.startingValue = 1
        }
    }
}

// MARK: - SelectPicker : Picker 선택부분
struct SelectPicker: View {
    
    /// showingSheet: Bool - PickerSheet 띄우기 Bool값 -> SelectPicker 클릭 시 -> true
    //@Binding var showingSheet: Bool
    /// selectedValue: Double? - 반환 받을 변수
    @Binding var selectedValue: Double?
    
    private let pickerType: PickerType
    private let pickerTypeInfo: PickerTypeInfo
    
    @State private var pickerPresented: Bool = false
    
    
    // MARK: - picker
    // 사용 예시
    // @State private var presentWindow: Bool = false
    // private var selectedValue: Double?
    //
    // SelectPicker(selectedValueBinding: selectedValue, showingSheet: $presentWindow, title: "체중", unit: "kg")
    
    ///  picker - selectedValue 반환 받을 값, pickerType : picker 종류
    init(selectedValue: Binding<Double?>, pickerType: PickerType) {
        self._selectedValue = selectedValue
        self.pickerType = pickerType
        self.pickerTypeInfo = PickerTypeInfo(pickerType: pickerType)
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 8){
                HStack(spacing:0){
                    Text(pickerTypeInfo.title)
                        .customFontStyle(.gray1_R16)
                    Text("(\(pickerTypeInfo.unit))")
                        .customFontStyle(.gray1_R12)
                }
                Button(action: {
                    pickerPresented.toggle()
                }, label: {
                    HStack{
                        if let value = selectedValue{
                            Text("\(String(format: pickerTypeInfo.format, value))\(pickerTypeInfo.unit)")
                                .customFontStyle(.gray1_M16)
                        }else{
                            Text("\(pickerTypeInfo.title)을 선택해주세요.")
                                .customFontStyle(.gray2_L16)
                        }
                        Spacer()
                        Image(.pickerLogo)
                            .resizable()
                            .frame(width: 9,height: 18)
                            .scaledToFit()
                    }
                })
                .padding(EdgeInsets(top: 14, leading: 10, bottom: 14, trailing: 10))
                .background(Capsule()
                    .foregroundStyle(.gray2)
                    .frame(height: 1), alignment: .bottom)
                
                .sheet(isPresented: $pickerPresented) {
                    PickerSheet(selectedValueBinding: $selectedValue, pickerType: pickerType, startingValue: pickerTypeInfo.startingValue)
                }
            }
        }
    }
}


// MARK: -  PickerSheet : Picker 선택 창 부분
struct PickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding private var selectedValueBinding: Double?
    
    @State private var startingValue: Double
    private let pickerTypeInfo: PickerTypeInfo
    
    /// selectedValueBinding: 반환 받을 변수,  title: 값 명칭(체중), unit: 단위(kg), selectedValue: 디폴트값 - 본인 채중 그대로 입력
    init(selectedValueBinding: Binding<Double?>, pickerType: PickerType, startingValue: Double) {
        self._selectedValueBinding = selectedValueBinding
        self._startingValue = State<Double>(initialValue: startingValue)
        self.pickerTypeInfo = PickerTypeInfo(pickerType: pickerType)
    }
    
    var body: some View {            
        
        VStack{
            Text("\(pickerTypeInfo.title) 입력")
            .customFontStyle(.gray1_B20)
            Picker(pickerTypeInfo.title, selection: $startingValue) {
                ForEach(pickerTypeInfo.rangeValues, id: \.self) { value in
                Text("\(String(format: pickerTypeInfo.format, value)) \(pickerTypeInfo.unit)")
                    .tag(value)
            }
        }
        .customFontStyle(.gray1_M16)
        .pickerStyle(WheelPickerStyle())
        .presentationDetents([.height(300)])
        HStack(spacing: 8){
            Button {
                dismiss()
            } label: {
                Text("취소")
                    .customFontStyle(.main_R16)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40)
                    .overlay(
                        Capsule()
                            .stroke( .main, lineWidth: 1)
                    )
            }
            Button {
                selectedValueBinding = startingValue
                dismiss()
            } label: {
                Text("확인")
                    .customFontStyle(.white_B16)
                    .frame(width: 212, height: 40)
                    .background(.main)
                    .clipShape(Capsule())
            }
        }
    }
    .padding(20)
    }
}
