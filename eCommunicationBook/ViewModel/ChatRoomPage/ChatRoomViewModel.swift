//
//  ChatRoomViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ChatRoomViewModel {
    
    var chatRoom: ChatRoom
    
    var conversationViewModel = ConversationViewModel()
    
    var onDead: (() -> Void)?
    
    init(model chatRoom: ChatRoom) {
        
        self.chatRoom = chatRoom
    }
    
    var id: String {
        
        return chatRoom.id
    }
    
    var members: [String] {
        
        return chatRoom.members
    }
    
    var messages: [Message]? {
        
        return chatRoom.messages
    }
    
    func onTap() {
        
        ChatroomManager.shared.conversationID = chatRoom.id
    }
}
