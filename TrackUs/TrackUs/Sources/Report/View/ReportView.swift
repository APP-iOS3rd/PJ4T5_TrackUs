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
    @State var selectedDate: Date? = Date()
    @State var selectedAge : AvgAge = .twenties
    @State private var selectedTab: CircleTab = .day
    @ObservedObject var viewModel = ReportViewModel.shared
    
    var body: some View {
        VStack {
            animate()
            
            switch viewModel.userLogLoadingState {
            case .loading:
                ReportLoadingView()
                //                selectView(selectedDate: $selectedDate, selectedAge: $selectedAge, selec: selectedPicker)
                //                    .redacted(reason: .placeholder)
            case .loaded:
                selectView(selectedDate: $selectedDate, selectedAge: $selectedAge, selectedTab: $selectedTab, selec: selectedPicker)
            case .error(_):
                Text("ERROR")
            }
        }
        .customNavigation {
            NavigationText(title: "리포트")
        }
        .onAppear {
            viewModel.fetchUserLog()
            viewModel.fetchUserAgeLog()
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
    @Binding var selectedDate: Date?
    @Binding var selectedAge : AvgAge
    @Binding var selectedTab: CircleTab
    var selec : ReportTab
    
    var body: some View {
        switch selec {
        case .report:
            MyReportView(selectedTab: $selectedTab, selectedDate: $selectedDate, selectedAge: $selectedAge)
                .transition(.move(edge: .leading))
        case .record:
            MyRecordView(selectedDate: $selectedDate)
                .transition(.move(edge: .trailing))
            
        }
    }
}

#Preview {
    ReportView()
}
