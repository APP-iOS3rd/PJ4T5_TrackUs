//
//  TeamIntroView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct TeamIntroView: View {
    var body: some View {
        Text("박선구, 박소희, 최주원, 권석기, 윤준성, 김지훈 Let's go!")
            .customNavigation {
                NavigationText(title: "팀 트랙어스")
            } left: {
                NavigationBackButton()
            }
    }
}

#Preview {
    TeamIntroView()
}
