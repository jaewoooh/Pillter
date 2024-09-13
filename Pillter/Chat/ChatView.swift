//
//  MultimodalChatView.swift
//  solo
//
//  Created by 이상원 on 8/1/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct ChatView: View {
    @State private var textInput = ""
    @State private var chatService = ChatService()
    @State private var photoPickerItems = [PhotosPickerItem]()
    @State private var selectedPhotoData = [Data]()
    @State private var showAlert = false //알림 상태
    
    @State var externalMessage: String? //ChatExplainController에서 전달된 메시지
    
    var body: some View {
        VStack {
            //로고
            Image(.chatPill)
                .resizable()
                .scaledToFit()
                .frame(width: 80)
            
            //메시지 리스트.
            ScrollViewReader(content: { proxy in
                ScrollView {
                    ForEach(chatService.messages.filter { $0.role != .system }) { chatMessage in
                        //메시지 뷰
                        chatMessageView(chatMessage)
                            .padding(.horizontal, 10)
                            .font(.footnote) //폰트사이즈 줄이기
                    }
                }
                .onChange(of: chatService.messages) {
                    guard let recentMessage = chatService.messages.last else { return }
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(recentMessage.id, anchor: .bottom)
                        }
                    }
                }
            })
            
            //이미지 프리뷰
            if selectedPhotoData.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10, content: {
                        ForEach(0..<selectedPhotoData.count, id: \.self) { index in
                            Image(uiImage: UIImage(data: selectedPhotoData[index])!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    })
                }
                .frame(height: 50)
            }
            
            // input 필드
            HStack {
                HStack {
                    PhotosPicker(selection: $photoPickerItems, maxSelectionCount: 3, matching: .images) {
                        Image(systemName: "photo.stack.fill")
                            .frame(width: 40, height: 25)
                    }
                    .onChange(of: photoPickerItems) {
                        Task {
                            selectedPhotoData.removeAll()
                            for item in photoPickerItems {
                                if let imageData = try await item.loadTransferable(type: Data.self) {
                                    selectedPhotoData.append(imageData)
                                }
                            }
                        }
                    }
                    
                    TextField("Hello ChatPill!", text: $textInput)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .foregroundStyle(.black)
                        .cornerRadius(15)
             
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            textInput = ""
                        }
                        
                        sendMessage()
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(20)
                    })
                }
                .padding(5)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 5)
            }
            .padding(.horizontal)
            .padding(.bottom, 60)
            .onAppear {
                if let message = externalMessage, !message.isEmpty {
                    textInput = message
                    //clearMessages()
                    sendMessage()
                    externalMessage = ""
                    
                }
            }
        }
        .foregroundStyle(.black)
        .padding()
        .background {
            ZStack {
                Color.white
            }
            .ignoresSafeArea()
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .navigationBarItems(trailing: Button(action: {
            showAlert = true // 알림 표시
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("대화를 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("예"), action: clearMessages),
                secondaryButton: .cancel(Text("아니오"))
            )
        }
    }
    
    //메시지 뷰
    @ViewBuilder private func chatMessageView(_ message: ChatMessage) -> some View {
        //챗 이미지
        if let images = message.images, images.isEmpty == false {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10, content: {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: UIImage(data: images[index])!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .containerRelativeFrame(.horizontal)
                    }
                })
                .scrollTargetLayout()
            }
            .frame(height: 100)
        }
        
        HStack(alignment: .bottom, spacing: 5) {
            
            if message.role == .model {
                Image("blue-robot")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    //.padding(.trailing, 5)
            }
            
            ChatBubble(direction: message.role == .model ? .left : .right) {
                Text(message.message)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .padding(.all, 10)
                    .foregroundStyle(.white)
                    .background(message.role == .model ? Color.gray : Color.blue)
            }
            
            if message.role != .model {
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
    
    //응답가져오기
    private func sendMessage() {
        Task {
        
            await chatService.sendMessage(message: textInput, imageData: selectedPhotoData)
            selectedPhotoData.removeAll()
            textInput = ""
        }
    }
    
    //메시지 삭제
    private func clearMessages()
    {
        chatService.clearMessages()
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
