
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
        
        // 기본적인 프롬프트 설정
        if messages.isEmpty
        {
            var systemPrompt =
            """
            모든 설명에 간단하게 대답해줘.
            """

            messages.append(.init(role: .system, message: systemPrompt, images: nil))
        }
        
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
            var fullResponse = "" // 전체 응답을 저장할 변수

            let outputStream = chatModel.generateContentStream(message, images)
            for try await chunk in outputStream {
                guard let text = chunk.text else {
                    return
                }
                
                fullResponse += text // 각 chunk를 fullResponse에 병합
            }
            
            let lastChatMessageIndex = messages.count - 1

            // 메세지를 AI가 보내기 전에 후처리
            var processedText = fullResponse

            // 약 관련 키워드 예시
            let medicineKeywords = ["약", "의약품", "복용", "효능", "부작용", "처방", "약국"]
            let containsMedicineKeywords = medicineKeywords.contains { keyword in
                processedText.contains(keyword)
            }
            
            // 이름 제미니를 챗필로 수정
            if processedText.contains("Gemini") {
                processedText = "저는 ChatPill입니다."
            }
            // 약 관련 키워드가 없는 경우
            else if !containsMedicineKeywords {
                processedText = "저는 약에 대한 질문만 답변할 수 있습니다."
            }

            messages[lastChatMessageIndex].message += processedText
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

