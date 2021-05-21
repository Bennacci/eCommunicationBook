//
//  Course.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Course: Codable {
  var id: String
  var name: String
  var teacher: [String]
  var student: [String]
  var firstLessonDate: Double
  var courseTime: [RoutineHour]
  var fee: Int
  var lessonsAmount: Int
  var lessons: [Lesson]?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case teacher
    case student
    case firstLessonDate
    case courseTime
    case fee
    case lessonsAmount
    case lessons
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "name": name as Any,
      "teacher": teacher as Any,
      "student": student as Any,
      "firstLessonDate": firstLessonDate as Any,
      "courseTime": courseTime as Any,
      "fee": fee as Any,
      "lessonsAmount": lessonsAmount as Any,
      "lessons": lessons as Any
    ]
  }
}
