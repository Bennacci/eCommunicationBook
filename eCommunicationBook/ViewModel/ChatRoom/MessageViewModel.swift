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
}
