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
        get {
          return chatRoom.id
        }
    }
    
  var members: [String] {
      get {
          return chatRoom.members
      }
  }
  
  var messages: [Message]? {
      get {
        return chatRoom.messages
      }
  }

  func onTap() {
    
    XXXManager.shared.conversationID = chatRoom.id
  }
}
