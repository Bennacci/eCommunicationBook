//
//  Lesson.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct Lesson: Codable {
    
    var id: String
    var number: Int
    var teacher: String
    var time: Double
    var timeInterval: Int
    var todaysLesson: [String]?
    var tests: [String]?
    var assignments: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case teacher
        case time
        case timeInterval
        case todaysLesson
        case tests
        case assignments
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "number": number as Any,
            "teacher": teacher as Any,
            "time": time as Any,
            "timeInterval": timeInterval as Any,
            "todaysLesson": todaysLesson as Any,
            "tests": tests as Any,
            "assignments": assignments as Any
        ]
    }
}
