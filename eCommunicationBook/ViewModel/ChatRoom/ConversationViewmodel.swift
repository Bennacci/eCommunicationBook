//
//  ConversationViewmodel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ConversationViewModel {
    
    var otherUserID = String.empty
    
    var user: User?
    
    let messageViewModel = Box([MessageViewModel]())
    
    var refreshView: (() -> Void)?
    
    var message: Message = Message(
        id: String.empty,
        content: String.empty,
        senderID: UserManager.shared.user.id,
        createdTime: -1
    )
    
    func onRefresh() {

        self.refreshView?()
    }
    
    func fetchData() {
        
        ChatroomManager.shared.fetchConversation { [weak self] result in
            
            switch result {
            
            case .success(let messages):
                
                self?.setConversations(messages)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func fetchUserData() {
        
        if otherUserID != String.empty {
            
            UserManager.shared.identifyUser(uid: otherUserID) { [weak self] result in
                
                switch result {
                
                case .success(let user):
                    
                    self?.user = user
                    
                    self?.onRefresh()
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                }
            }
        }
    }
    
    func onContentChanged(text content: String) {
        
        self.message.content = content
    }
    
    var onSend: (() -> Void)?
    
    func resetMessageContent() {
        
        message.content = String.empty
    }
    
    func onTapSend() {
        
        if hasContent() {
            
            sendMessage(with: &message)
        }
    }
    
    func sendMessage(with message: inout Message) {
        
        ChatroomManager.shared.sendMessage(message: &message) { result in
            
            switch result {
            
            case .success:
                
                self.onSend?()
                
                self.resetMessageContent()
                                
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
    }
    
    func hasContent() -> Bool {
        
        return message.content != String.empty
    }
    
    func convertMessagesToViewModels(from messages: [Message]) -> [MessageViewModel] {
        
        var viewModels = [MessageViewModel]()
        
        for message in messages {
            
            let viewModel = MessageViewModel(model: message)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setConversations(_ conversations: [Message]) {
        
        messageViewModel.value = convertMessagesToViewModels(from: conversations)
    }
}
