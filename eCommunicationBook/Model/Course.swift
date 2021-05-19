//
//  Course.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Course: Codable {
  let id: String
  let name: String
  let teacher: [String]
  let student: [String]
  let courseTime: [RoutineHour]
  let fee: Int
  let lesson: [Lesson]
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case teacher
    case student
    case courseTime
    case fee
    case lesson
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "name": name as Any,
      "teacher": teacher as Any,
      "student": student as Any,
      "courseTime": courseTime as Any,
      "fee": fee as Any,
      "lesson": lesson as Any
    ]
  }
}
