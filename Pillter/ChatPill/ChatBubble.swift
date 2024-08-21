
//  ChatBubble.swift
//  solo
//
//  Created by 이상원 on 8/1/24.
//

import Foundation
import SwiftUI

struct ChatBubble<Content>: View where Content: View {
    
    let direction: ChatBubbleShape.Direction // #MARK: 채팅 방향(왼, 오)
    let content: () -> Content
    
    // #MARK: 초기화
    init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
            self.content = content
            self.direction = direction
    }
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            content()
                .clipShape(ChatBubbleShape(direction: direction))  
            if direction == .left {
                Spacer()
            }
        }.padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 5)
        .padding((direction == .right) ? .leading : .trailing, 10)
    }
}
