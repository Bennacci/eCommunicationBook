//
//  Student.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Student: Codable {
  let id: String
  let parents: [String]
  let name: String
  let image: String?
  let nationalID: String
  let grade: Int
  let birthDay: Double
  let emergencyContactPaerson: String
  let emergencyContactNo: Int
  
  enum CodingKeys: String, CodingKey {
    case id
    case parents
    case name
    case image
    case nationalID
    case grade
    case birthDay
    case emergencyContactPaerson
    case emergencyContactNo
    
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "parents": parents as Any,
      "name": name as Any,
      "image": image as Any,
      "nationalID": nationalID as Any,
      "grade": grade as Any,
      "birthDay": birthDay as Any,
      "emergencyContactPaerson": emergencyContactPaerson as Any,
      "emergencyContactNo": emergencyContactNo as Any
    ]
  }
}
