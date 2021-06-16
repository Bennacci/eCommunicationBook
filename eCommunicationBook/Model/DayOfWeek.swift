//
//  DayOfWeek.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

enum DayOfWeek: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wendnesday = 4
    case thrusday = 5
    case friday = 6
    case saturday = 7
    
    var title: String {
        switch self {
        
        case .sunday: return localizedString("星期日")
            
        case .monday: return localizedString("星期一")
            
        case .tuesday: return localizedString("星期二")
            
        case .wendnesday: return localizedString("星期三")
            
        case .thrusday: return localizedString("星期四")
            
        case .friday: return localizedString("星期五")
            
        case .saturday: return localizedString("星期六")
        }
    }
}
