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
  let id: String
  let attendTime: Double
  let leftTime: Double
  let performance: [ClassPerformance.RawValue]
  let testGrade: [Int]?
  let assignmentCompleted: [Bool]?
  let assignmentScore: [Int]?
  let note: String?

  enum CodingKeys: String, CodingKey {
    case id
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
