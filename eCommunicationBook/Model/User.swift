//
//  User.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct User: Codable {
  let id: String
  let userID: String
  let name: String
  let image: String
  let cellPhoneNo: Int
  let homePhoneNo: Int
  let birthDay: Double
  let email: String
  let userType: UserType.RawValue
  let workingHours: [RoutineHour]?
  let dificulty: [Int]?
  let note: [String]?
  
  enum CodingKeys: String, CodingKey {
    case id
    case userID
    case name
    case image
    case cellPhoneNo
    case homePhoneNo
    case birthDay
    case email
    case userType
    case workingHours
    case dificulty
    case note
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "userID": userID as Any,
      "name": name as Any,
      "image": image as Any,
      "cellPhoneNo": cellPhoneNo as Any,
      "homePhoneNo": homePhoneNo as Any,
      "birthDay": birthDay as Any,
      "email": email as Any,
      "userType": userType as Any,
      "workingHours": workingHours as Any,
      "dificulty": dificulty as Any,
      "note": note as Any,
    ]
  }
}
