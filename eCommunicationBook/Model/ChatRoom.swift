//
//  ChatRoom.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct ChatRoom: Codable {
    var id: String
    var members: [String]
    var createdTime: Double
    var messages: [Message]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case members
        case messages
        case createdTime
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "members": members as Any,
            "createdTime": createdTime as Any
//            "messages": messages as Any
        ]
    }
}
