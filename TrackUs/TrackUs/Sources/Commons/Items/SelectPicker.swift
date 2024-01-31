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


// MARK: - SelectPicker : Picker 선택부분
struct SelectPicker: View {
    
    /// showingSheet: Bool - PickerSheet 띄우기 Bool값 -> SelectPicker 클릭 시 -> true
    @Binding var showingSheet: Bool
    /// selectedValue: Double? - 반환 받을 변수
    @State var selectedValue: Double?
    
    private let title: String
    private let unit: String
    private let format: String
    
    
    // MARK: - picker 소수점 없는 경우
    // 사용 예시
    // @State private var presentWindow: Bool = false
    // private var selectedValue: Double?
    //
    // SelectPicker(selectedValueBinding: selectedValue, showingSheet: $presentWindow, title: "체중", unit: "kg")
    
    ///  picker 소수점 없는 경우
    init(selectedValue: Double? = nil, showingSheet: Binding<Bool>, title: String, unit: String) {
        self.selectedValue = selectedValue
        self._showingSheet = showingSheet
        self.title = title
        self.unit = unit
        self.format = "%.0f"
    }
    
    // MARK: - picker 소수점 있는 경우
    // 사용 예시
    // SelectPicker(selectedValueBinding: selectedValue, showingSheet: $presentWindow, title: "일일 운동량", unit: "km", format: "1")
    
    ///  picker 소수점( 있는 경우 -  format 생략시 (1자리), format: "n" (n자리)
    init(selectedValue: Double? = nil, showingSheet: Binding<Bool>, title: String, unit: String, format: String = "1") {
        self.selectedValue = selectedValue
        self._showingSheet = showingSheet
        self.title = title
        self.unit = unit
        self.format = "%.\(format)f"
    }
    
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack(spacing:0){
                    Text(title)
                        .font(.system(size: 16, weight: .regular))
                    Text("(\(unit))")
                        .font(.system(size: 12, weight: .regular))
                }
                Button(action: {
                    showingSheet.toggle()
                }, label: {
                    HStack{
                        if let value = selectedValue{
                            Text("\(String(format: format, value))\(unit)")
                                .foregroundStyle(.black)
                        }else{
                            Text("\(title)을 선택해주세요.")
                                .foregroundStyle(.gray2)
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
                            // 회색 지정 후 수정 ‼️‼️
                    .foregroundStyle(.gray)
                    .frame(height: 1), alignment: .bottom)
            }
        }
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


//#Preview {
//    SelectPicker()
//}
