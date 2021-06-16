//
//  Date+Extension.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/12.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    
    /// Time
    case time = "HH:mm"
    
    case timeHr = "HH"
    
    case timeMin = "mm"
    
    /// Date with hours
    case dateWithTime = "yyyy-MMM-dd H:mm"
    
    case dateWithTimeWithOutYear = "MMM-dd H:mm"
    
    /// Date
    case date = "dd-MMM-yyyy"
    
    case dateYMD = "yyyy-MMM-dd"
    
    case dateMD = "MMM-dd"
    
    /// Date components
    case year = "yyyy"
    
    case month = "MMM"
    
    case day = "dd"
    
}

extension Date {
    
    /// Convert date to double
    var millisecondsSince1970: Double {
        
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
    
    init(milliseconds: Double) {
        
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    /// Convert date to string
    func convertToString(dateformat formatType: DateFormatType) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = formatType.rawValue
        
        let newDate: String = dateFormatter.string(from: self)
        
        return newDate
    }
}
