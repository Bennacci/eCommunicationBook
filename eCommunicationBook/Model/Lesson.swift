//
//  Lesson.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Lesson: Codable {
  let id: String
  let teacher: String
  let time: Double
  let timeInterval: Double
  let tests: [String]?
  let assignments: [String]?
 
  enum CodingKeys: String, CodingKey {
    case id
    case teacher
    case time
    case timeInterval
    case tests
    case assignments
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "teacher": teacher as Any,
      "time": time as Any,
      "timeInterval": time as Any,
      "tests": tests as Any,
      "assignments": assignments as Any
    ]
  }
}
