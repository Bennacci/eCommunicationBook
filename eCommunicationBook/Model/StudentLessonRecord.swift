//
//  StudentPerformance.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

enum ClassPerformance: Int {
  case terrible = 1
  case poor = 2
  case okay = 3
  case good = 4
  case excellent = 5
}

struct StudentLessonRecord: Codable {
  var id: String
  var studentID: String
  var courseName: String
  var time: Double
  var timeInterval: Int
  var todaysLesson: [String]?
  var tests: [String]?
  var assignments: [String]?
  var performances: [ClassPerformance.RawValue]
  var previousTests: [String]?
  var previousAssignments: [String]?
  var testGrade: [String]?
  var assignmentCompleted: [Bool]?
  var assignmentScore: [Int]?
  var note: String?

  enum CodingKeys: String, CodingKey {
    case id
    case studentID
    case courseName
    case time
    case timeInterval
    case todaysLesson
    case tests
    case assignments
    case performances
    case previousTests
    case previousAssignments
    case testGrade
    case assignmentCompleted
    case assignmentScore
    case note
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "studentID": studentID as Any,
      "courseName": courseName as Any,
      "time": time as Any,
      "timeInterval": timeInterval as Any,
      "todaysLesson": todaysLesson as Any,
      "tests": tests as Any,
      "assignments": assignments as Any,
      "performances": performances as Any,
      "previousTests": previousTests as Any,
      "previousAssignments": previousAssignments as Any,
      "testGrade": testGrade as Any,
      "assignmentCompleted": assignmentCompleted as Any,
      "assignmentScore": assignmentScore as Any,
      "note": note as Any
    ]
  }
}
