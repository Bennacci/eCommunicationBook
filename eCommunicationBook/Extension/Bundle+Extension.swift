//
//  Bundle+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/6.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

extension Bundle {
    // swiftlint:disable force_cast
    static func STValueForString(key: String) -> String {
        
        return Bundle.main.infoDictionary![key] as! String
    }

    static func STValueForInt32(key: String) -> Int32 {

        return Bundle.main.infoDictionary![key] as! Int32
    }
    // swiftlint:enable force_cast
}
