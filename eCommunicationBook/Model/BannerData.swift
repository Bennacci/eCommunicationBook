//
//  Banner.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct BannerData: Codable {
    
    var id: Int
    var picture: String
    var story: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case picture
        case story
    }
}
