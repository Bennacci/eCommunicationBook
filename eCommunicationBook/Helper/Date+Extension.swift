//
//  DateHelper.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//

import Foundation


/// Date Format type
enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    
    /// Date with hours
    case dateWithTime = "dd-MMM-yyyy  H:mm"
    
    /// Date
    case date = "dd-MMM-yyyy"
  
    case dateYMD = "yyyy-MMM-dd"
    
}

extension Date {
    var millisecondsSince1970: Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
    
    init(milliseconds: Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    static var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
                
        return formatter
        
    }
    static var dateFormatterYMD: DateFormatter = {
    
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter
    }()
  
  func convertToString(dateformat formatType: DateFormatType) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = formatType.rawValue
      let newDate: String = dateFormatter.string(from: self)
      return newDate
  }
}
