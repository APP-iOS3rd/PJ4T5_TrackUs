//
//  RunningHomeView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/04.
//

import SwiftUI

struct RunningHomeView: View {
    @State private var isOpen: Bool = false
    @State private var maxHeight: CGFloat = 300
    
    var body: some View {
        ZStack {
            MapBoxMapView()
                
            BottomSheet(isOpen: $isOpen, maxHeight: maxHeight + 44, minHeight: maxHeight / 6 + 24) {
                VStack {
                    Text("Test1")
                        .padding(20)
                        .background(.blue)
                    Text("Test2")
                        .padding(20)
                        .background(.blue)
                    Text("Test3")
                        .padding(20)
                        .background(.blue)
                    Text("Test4")
                        .padding(20)
                        .background(.blue)
                    Text("Test5")
                        .padding(20)
                        .background(.blue)
                    Text("Test6")
                        .padding(20)
                        .background(.blue)
                }
                .background(
                    GeometryReader { innerGeometry in
                        Color.red
                            .onAppear {
                                self.maxHeight = innerGeometry.size.height
                            }
                    }
                )
            }
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    RunningHomeView()
}
