//
//  RunningView.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import SwiftUI

struct RunningView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            List(1..<10) { number in
                NavigationLink("화면이동 테스트 \(number)", value: number)
                    .navigationDestination(for: Int.self) { number in
                        self
                    }
            }
            
            Button(action: {router.push(to: .report)}, label: {
                Text("리포트 뷰로")
            })
            
            Button(action: {router.pop()}, label: {
                Text("이전 화면으로")
            })
            
            Button(action: {router.popToRoot()}, label: {
                Text("처음 화면으로")
            })
        }
    }
}

#Preview {
    RunningView()
}
