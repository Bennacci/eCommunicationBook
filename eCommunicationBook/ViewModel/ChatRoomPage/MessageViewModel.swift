//
//  MessageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/16.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class MessageViewModel {
    
    var message: Message
    
    //  var onDead: (()->())?
    
    init(model message: Message) {
        self.message = message
    }
    
    var id: String {
        
        return message.id
    }
    
    var content: String {
        
        return message.content
    }
    
    var senderID: String {
        
        return message.senderID
    }
    
    var createdTime: Double {
        
        return message.createdTime
    }
    
    func onContentChanged(text content: String) {
        
        self.message.content = content
    }
    //  func onTap() {
    //      XXXManager.shared.deleteArticle(article: article) { [weak self] result in
    //
    //          switch result {
    //
    //          case .success(let articleId):
    //
    //              print(articleId)
    //              self?.onDead?()
    //
    //          case .failure(let error):
    //
    //              print("publishArticle.failure: \(error)")
    //          }
    //      }
    //  }
}
