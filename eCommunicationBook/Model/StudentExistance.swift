//
//  StudentExistance.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/30.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct StudentExistance: Codable {
  
  var id: String
  var studentID: String
  var studentName: String
  var time: Double
  var latitude: Double
  var longitude: Double
  var scanTeacherName: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case studentID
    case studentName
    case time
    case latitude
    case longitude
    case scanTeacherName
  }
  
  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "studentID": studentID as Any,
      "studentName": studentName as Any,
      "time": time as Any,
      "latitude": latitude as Any,
      "longitude": longitude as Any,
      "scanTeacherName": scanTeacherName as Any
    ]
  }
}
