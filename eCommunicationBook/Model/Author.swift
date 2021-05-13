//
//  Author.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//

import Foundation

struct Author: Codable {
    let id: String
    let email: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "email": email as Any,
            "name": name as Any
        ]
    }
}
