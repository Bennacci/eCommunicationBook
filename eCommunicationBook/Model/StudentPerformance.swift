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

struct StudentPerformance: Codable {
  var id: String
  var courseName: String
  var date: Double
  var courseTime: RoutineHour
  var attendTime: Double
  var leftTime: Double
  var performance: [ClassPerformance.RawValue]
  var testGrade: [Int]?
  var assignmentCompleted: [Bool]?
  var assignmentScore: [Int]?
  var note: String?

  enum CodingKeys: String, CodingKey {
    case id
    case courseName
    case date
    case courseTime
    case attendTime
    case leftTime
    case performance
    case testGrade
    case assignmentCompleted
    case assignmentScore
    case note
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "courserName": courseName as Any,
      "date": date as Any,
      "courseTime": courseTime.toDict as Any,
      "attendTime": attendTime as Any,
      "attendTime": attendTime as Any,
      "leftTime": leftTime as Any,
      "performance": performance as Any,
      "testGrade": testGrade as Any,
      "assignmentCompleted": assignmentCompleted as Any,
      "assignmentScore": assignmentScore as Any,
      "note": note as Any
    ]
  }
}
