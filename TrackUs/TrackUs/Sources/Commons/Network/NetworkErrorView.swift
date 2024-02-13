//
//  NetworkErrorView.swift
//  TrackUs
//
//  Created by 박선구 on 2/8/24.
//

import SwiftUI

struct NetworkErrorView: View {
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.Gray1)
                .padding()
            
            Text("네트워크 연결을 확인해주세요")
                .customFontStyle(.gray1_B16)
                .padding()
        }
        .background(Color.gray3)
        .cornerRadius(10)
    }
}

#Preview {
    NetworkErrorView()
}
