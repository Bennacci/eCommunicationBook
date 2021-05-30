//
//  ConversationViewmodel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ConversationViewModel {
  
  let messageViewModel = Box([MessageViewModel]())
  
  var refreshView: (()->())?
  
  //  var scrollToTop: (()->())?
  
  var message: Message = Message(
    id: "",
    content: "",
    senderID: UserManager.shared.userID ?? "",
    createdTime: -1
  )
  
  func onRefresh() {
    // maybe do something
    self.refreshView?()
  }
  
  func fetchData() {
    
    XXXManager.shared.fetchConversation { [weak self] result in
      
      switch result {
        
      case .success(let messages):
        
        self?.setConversations(messages)
        
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
  func onContentChanged(text content: String) {
    self.message.content = content
  }
  
  var onPublished: (()->())?

  
  func onTapSend() {

    if hasIDInMessage() {
      print("has sender in message...")
      if hasContent() {
        publish() // MARK: check which function this call is
      } else {
        print("but no content")
      }
    } else {
      print("login...")
      UserManager.shared.login() { [weak self] result in
        // MARK: - put your id into login function
        switch result {
          
        case .success(let id):
          
          print("login success")
          self?.publish(with: id) // MARK: check which function this call is
          
        case .failure(let error):
          
          print("login.failure: \(error)")
        }
      }
    }
  }
  
  func publish(with message: inout Message) {
    XXXManager.shared.sendMessage(message: &message) { result in
      
      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        self.onPublished?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
  func publish(with id: String? = nil) {
    
    if let senderID = id {
      message.senderID = senderID
    }
    
    publish(with: &message) // MARK: check which function this call is
  }
  func hasContent() -> Bool {
    return message.content != ""
  }
  func hasIDInMessage() -> Bool {
    return true
//    return message.senderID != nil
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
