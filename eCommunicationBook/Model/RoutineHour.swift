//
//  RoutineHour.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct RoutineHour: Codable {
    
    var day: Int
    var startingTime: Int
    var timeInterval: Int
    
    enum CodingKeys: String, CodingKey {
        case day
        case startingTime
        case timeInterval
    }
    
    var toDict: [String: Any] {
        return [
            "day": day as Any,
            "startingTime": startingTime as Any,
            "timeInterval": timeInterval as Any
        ]
    }
}
