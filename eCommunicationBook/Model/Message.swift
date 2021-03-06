//
//  Message.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    var id: String
    var content: String
    var senderID: String
    var createdTime: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case senderID
        case createdTime
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "content": content as Any,
            "senderID": senderID as Any,
            "createdTime": createdTime as Any
        ]
    }
}
