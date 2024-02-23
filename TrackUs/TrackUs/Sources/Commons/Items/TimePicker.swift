//
//  TimePicker.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI


struct TimePicker: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    var formattedHours: String {
        String(format: "%02d", hours)
    }
    
    var formattedMinutess: String {
        String(format: "%02d", minutes)
    }
    
    var formattedSeconds: String {
        String(format: "%02d", seconds)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("🏃🏻 ")
                Text(formattedHours)
                    .customFontStyle(.main_B16)
                Text("시간")
                    .customFontStyle(.gray1_M16)
                Text(formattedMinutess)
                    .customFontStyle(.main_B16)
                Text("분")
                    .customFontStyle(.gray1_M16)
                
                Text(formattedSeconds)
                    .customFontStyle(.main_B16)
                Text("초")
                    .customFontStyle(.gray1_M16)
                Spacer()
            }
            
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text( String(format: "%02d", hour))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)

                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text( String(format: "%02d", minute))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)

                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60, id: \.self) { second in
                        Text( String(format: "%02d", second))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
            }
        }
        .padding()
        
    }

    var formattedTime: String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    TimePicker(hours: .constant(0), minutes: .constant(0), seconds: .constant(0))
}
