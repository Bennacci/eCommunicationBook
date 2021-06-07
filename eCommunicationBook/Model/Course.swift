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
  var teachers: [String]
  var students: [String]
  var firstLessonDate: Double
  var courseTime: [RoutineHour]
  var fee: Int
  var lessonsAmount: Int
  var lessons: [Lesson]?
  var image: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case teachers
    case students
    case firstLessonDate
    case courseTime
    case fee
    case lessonsAmount
    case lessons
    case image
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "name": name as Any,
      "teachers": teachers as Any,
      "students": students as Any,
      "firstLessonDate": firstLessonDate as Any,
      "courseTime": courseTime.map({$0.toDict}) as Any,
      "fee": fee as Any,
      "lessonsAmount": lessonsAmount as Any,
      "lessons": lessons as Any,
      "image": image as Any
    ]
  }
}
