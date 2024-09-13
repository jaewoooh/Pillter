
//  Chat.swift
//  solo
//
//  Created by 이상원 on 8/1/24.
//

import Foundation

enum ChatRole {
    case user
    case model
    case system
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var role: ChatRole
    var message: String
    var images: [Data]?
}
