//
//  ChatViewModel.swift
//  TrackUs
//
//  Created by 최주원 on 2/23/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
}
