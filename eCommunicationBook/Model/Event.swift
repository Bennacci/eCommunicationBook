//
//  Event.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    var id: String
    var eventName: String
    var description: String
    var image: String?
    var date: Double
    var time: Int
    var timeInterval: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventName
        case description
        case image
        case date
        case time
        case timeInterval
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "eventName": eventName as Any,
            "description": description as Any,
            "image": image as Any,
            "date": date as Any,
            "time": time as Any,
            "timeInterval": timeInterval as Any
        ]
    }
}
