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

// MARK: - SelectPicker : Picker 선택부분
struct SelectPicker: View {
    
    /// showingSheet: Bool - PickerSheet 띄우기 Bool값 -> SelectPicker 클릭 시 -> true
    //@Binding var showingSheet: Bool
    /// selectedValue: Double? - 반환 받을 변수
    @Binding var selectedValue: Double?
    
    private let pickerType: PickerType
    private var title: String
    private var unit: String
    private var format: String
    private var rangeValues: [Double]
    
    @State private var startValue: Double // picker 시작값
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
        switch pickerType {
        case .height:
            self.title = "키"
            self.unit = "cm"
            self.format = "%.0f"
            self.rangeValues = stride(from: 100, through: 250, by: 1).map { $0 }
            self.startValue = 160
        case .weight:
            self.title = "체중"
            self.unit = "kg"
            self.format = "%.0f"
            self.rangeValues = stride(from: 30, through: 200, by: 1).map { $0 }
            self.startValue = 50
        case .age:
            self.title = "나이대"
            self.unit = "대"
            self.format = "%.0f"
            self.rangeValues = stride(from: 10, through: 60, by: 10).map { $0 }
            self.startValue = 30
        case .dailyGoal:
            self.title = "일일 운동량"
            self.unit = "km"
            self.format = "%.1f"
            self.rangeValues = stride(from: 0, through: 40, by: 0.1).map { $0 }
            self.startValue = 1
        }
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 8){
                HStack(spacing:0){
                    Text(title)
                        .customFontStyle(.gray1_R16)
                    Text("(\(unit))")
                        .customFontStyle(.gray1_R12)
                }
                Button(action: {
                    pickerPresented.toggle()
                }, label: {
                    HStack{
                        if let value = selectedValue{
                            Text("\(String(format: format, value))\(unit)")
                                .customFontStyle(.gray1_M16)
                        }else{
                            Text("\(title)을 선택해주세요.")
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
                    PickerSheet2(selectedValueBinding: $selectedValue, title: title, unit: unit, format: format, rangeValues: rangeValues, selectedValue: $startValue)
                }
            }
        }
    }
    
    func pickerSetting(){
        
    }
}


// MARK: -  PickerSheet : Picker 선택 창 부분
struct PickerSheet: View {
    
    @Binding private var selectedValueBinding: Double?
    @Binding private var check: Bool
    
    private let title: String
    private let unit: String
    private let format: String = "%.0f"
    // stride(from: 20, through: 220, by: 10).map { $0 }
    private let rangeValues: [Double]
    @State private var selectedValue: Double
    
    /*
     가장 상단에 있는 view에 추가
     .overlay(alignment: .center) {
                 if pickercheck {
                     PickerSheet(selectedValueBinding: $value, check: $pickercheck, title: "체중", unit: "kg", rangeFrom: 20, rangeThrough: 150, rangeBy: 1, selectedValue: 70)
                         .frame(maxWidth: .infinity, maxHeight: .infinity)
                         .background(!pickercheck ? Color.white : Color.black.opacity(0.45))
                         .edgesIgnoringSafeArea(.all)
                 }
             }
             .animation(.easeOut(duration: 0.5), value: pickercheck)
     */
    
    /// selectedValueBinding: 반환 받을 변수, check: picker띄우기 여부(Bool), title: 값 명칭(체중), unit: 단위(kg), selectedValue: 디폴트값
    init(selectedValueBinding: Binding<Double?>, check: Binding<Bool>, title: String, unit: String, rangeFrom: Double, rangeThrough: Double, rangeBy: Double, selectedValue: Double) {
        self._selectedValueBinding = selectedValueBinding
        self._check = check
        self.title = title
        self.unit = unit
        self.rangeValues = stride(from: rangeFrom, through: rangeThrough, by: rangeBy).map { $0 }
        self.selectedValue = selectedValue
    }
    
    
    var body: some View {
        VStack{            
            Text("\(title) 입력")
                .font(.system(size: 20,weight: .bold))
            Picker(title, selection: $selectedValue) {
                ForEach(rangeValues, id: \.self) { value in
                    Text("\(String(format: format, value)) \(unit)")
                        .tag(value)
                }
            }
            .frame(width: 320)
            .foregroundStyle(.black)
            .pickerStyle(WheelPickerStyle())
            //.labelsHidden()  // 레이블 숨기기
            //.presentationDetents([.height(300)])
            
            HStack(spacing: 8){
                Button("취소") {
                    check.toggle()
                }
                .fontWeight(.semibold)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40)
                .overlay(
                    Capsule()
                        .stroke( .main, lineWidth: 1)
                )
                Button("확인") {
                    selectedValueBinding = selectedValue
                    check.toggle()
                }
                .frame(width: 212, height: 40)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .background(.main)
                .clipShape(Capsule())
            }
        }
        .frame(width: 380,height: 400)
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .foregroundStyle(.white)
                .padding(.all, 16)
        )
    }
}

struct PickerSheet2: View {
    @Environment(\.dismiss) var dismiss
    @Binding private var selectedValueBinding: Double?
    @Binding private var selectedValue: Double
    
    private let title: String
    private let unit: String
    private let format: String
    private let rangeValues: [Double]
    
    /// selectedValueBinding: 반환 받을 변수, check: picker띄우기 여부(Bool), title: 값 명칭(체중), unit: 단위(kg), selectedValue: 디폴트값
    init(selectedValueBinding: Binding<Double?>, title: String, unit: String, format: String, rangeValues: [Double], selectedValue: Binding<Double>) {
        self._selectedValueBinding = selectedValueBinding
        self.title = title
        self.unit = unit
        self.format = format
        self.rangeValues = rangeValues
        self._selectedValue = selectedValue
    }
    
    var body: some View {            
        VStack{
        Text("\(title) 입력")
            .customFontStyle(.gray1_B20)
        Picker(title, selection: $selectedValue) {
            ForEach(rangeValues, id: \.self) { value in
                Text("\(String(format: format, value)) \(unit)")
                    .tag(value)
            }
        }
        .customFontStyle(.gray1_M16)
        .pickerStyle(WheelPickerStyle())
        .presentationDetents([.height(300)])
        HStack(spacing: 8){
            Button("취소") {
                dismiss()
            }
            .fontWeight(.semibold)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40)
            .overlay(
                Capsule()
                    .stroke( .main, lineWidth: 1)
            )
            Button("확인") {
                selectedValueBinding = selectedValue
                dismiss()
            }
            .frame(width: 212, height: 40)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .background(.main)
            .clipShape(Capsule())
        }
    }
    .padding(20)
    }
}

