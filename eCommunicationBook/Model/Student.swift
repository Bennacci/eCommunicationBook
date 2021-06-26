//
//  Student.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Student: Codable {
    
    var id: String
    var parents: [String]
    var name: String
    var image: String?
    var nationalID: String
    var grade: Int
    var birthDay: Double
    var emergencyContactPerson: String
    var emergencyContactNo: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case parents
        case name
        case image
        case nationalID
        case grade
        case birthDay
        case emergencyContactPerson
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
            "emergencyContactPerson": emergencyContactPerson as Any,
            "emergencyContactNo": emergencyContactNo as Any
        ]
    }
}
