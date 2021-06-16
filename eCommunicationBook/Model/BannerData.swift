//
//  Banner.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct BannerData: Codable {
    
    let id: Int
    
    //    let productId: Int
    
    let picture: String
    
    let story: String
    
    enum CodingKeys: String, CodingKey {
        case id
        //          case productId = "product_id"
        case picture
        case story
    }
}
