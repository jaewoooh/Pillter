
//  ChatService.swift
//  solo
//
//  Created by 이상원 on 8/1/24.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

@Observable
class ChatService {
    private var proModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    private var proVisionModel = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    private(set) var messages = [ChatMessage]()
    private(set) var loadingResponse = false //응답 여부
    
    // MARK: 메시지 보내는 함수
    func sendMessage(message: String, imageData: [Data]) async {
        
        loadingResponse = true
        
        //사용자, ai 메시지 모델
        messages.append(.init(role: .user, message: message, images: imageData))
        messages.append(.init(role: .model, message: "", images: nil))
        
        do {
            //이미지 여부에 따라 모델 결정
            let chatModel = imageData.isEmpty ? proModel : proVisionModel
            
            var images = [any ThrowingPartsRepresentable]()
            for data in imageData {
                // 이미지가 허용되는 최대크기 4MB
                if let compressedData = UIImage(data: data)?.jpegData(compressionQuality: 0.1) {
                    images.append(ModelContent.Part.jpeg(compressedData))
                }
            }
            
            // 요청, 응답
            let outputStream = chatModel.generateContentStream(message, images)
            for try await chunk in outputStream {
                guard let text = chunk.text else {
                    return
                }
                let lastChatMessageIndex = messages.count - 1
                messages[lastChatMessageIndex].message += text
            }
            
            loadingResponse = false
        }
        catch { //오류 발생시
            loadingResponse = false
            messages.removeLast()
            messages.append(.init(role: .model, message: "다시 시도해주세요."))
            print(error.localizedDescription) //오류가 뭔지 출력
        }
    }
    
    func clearMessages()
    {
        messages.removeAll()
    }
}
