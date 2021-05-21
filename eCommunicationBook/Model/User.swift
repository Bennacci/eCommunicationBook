//
//  User.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct User: Codable {
  var id: String
  var createdTime: Double
  var userID: String
  var name: String
  var image: String?
  var cellPhoneNo: Int
  var homePhoneNo: Int
  var birthDay: Double
  var email: String
  var userType: UserType.RawValue
  var workingHours: [RoutineHour]?
  var difficulty: [Int]?
  var note: [String]?
  
  enum CodingKeys: String, CodingKey {
    case id
    case createdTime
    case userID
    case name
    case image
    case cellPhoneNo
    case homePhoneNo
    case birthDay
    case email
    case userType
    case workingHours
    case difficulty
    case note
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "createdTime": createdTime as Any,
      "userID": userID as Any,
      "name": name as Any,
      "image": image as Any,
      "cellPhoneNo": cellPhoneNo as Any,
      "homePhoneNo": homePhoneNo as Any,
      "birthDay": birthDay as Any,
      "email": email as Any,
      "userType": userType as Any,
      "workingHours": workingHours as Any,
      "difficulty": difficulty as Any,
      "note": note as Any
    ]
  }
}
