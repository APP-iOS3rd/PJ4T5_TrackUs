//
//  ReportView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI
//import FirebaseFirestore

enum ReportTab: String, CaseIterable {
    case report = "리포트"
    case record = "러닝 기록"
}

struct ReportView: View {
    @State private var selectedPicker: ReportTab = .report
    @Namespace private var animation
    
    var body: some View {
        VStack {
            animate()
            selectView(selec: selectedPicker)
        }
        .customNavigation {
            NavigationText(title: "리포트")
        }
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(ReportTab.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity/2, minHeight: 10)
                        .customFontStyle(selectedPicker == item ? .main_SB16 : .gray1_SB16)
                    
                    if selectedPicker == item {
                        Rectangle()
                            .foregroundColor(.main)
                            .frame(height: 4)
                            .matchedGeometryEffect(id: "report", in: animation)
                            .offset(y: 7)
                    } else {
                        Rectangle()
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 1.0, opacity: 0.0))
                            .frame(height: 4)
                            .offset(y: 7)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
}

struct selectView : View {
    var selec : ReportTab
    
    var body: some View {
        switch selec {
        case .report:
            MyReportView()
        case .record:
            MyRecordView()
            
        }
    }
}

#Preview {
    ReportView()
}
