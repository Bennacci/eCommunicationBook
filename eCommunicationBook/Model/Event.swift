//
//  Event.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Event: Codable {
  let id: String
  let eventName: String
  let image: String?
  let time: Double
  let timeInterval: Double


 
  enum CodingKeys: String, CodingKey {
    case id
    case eventName
    case image
    case time
    case timeInterval
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "eventName": eventName as Any,
      "image": image as Any,
      "time": time as Any,
      "timeInterval": timeInterval as Any
    ]
  }
}
