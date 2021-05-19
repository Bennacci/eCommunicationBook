//
//  Article.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//

import Foundation

struct Article: Codable {
    
    var id: String
    var title: String
    var content: String
    var createdTime: Int64
    var category: String
    var author: Author?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdTime
        case category = "tag"
        case author
    }
    
    var toDict: [String: Any] {
        return [
            "id": id as Any,
            "title": title as Any,
            "content": content as Any,
            "createdTime": createdTime as Any,
            "tag": category as Any,
            "author": author?.toDict as Any
        ]
    }
}
