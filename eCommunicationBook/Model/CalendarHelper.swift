//
//  CalendarHelper.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/21.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation


class CalendarHelper {
  
  static let shared = CalendarHelper()
  
  let secondsPerDay: Double = (24 * 60 * 60)
  
  let selectedDays: [DayOfWeek] = []
//    ex: [ .monday, .wendnesday, .sunday, .saturday ]
  
  let calendar = Calendar.current
  
  func nextWeekday(weekDay: [DayOfWeek.RawValue]) -> Int {
    
    let weekdaySet = IndexSet(weekDay) // Sun, Mon, Wed and Sat
    
    let weekday = calendar.component(.weekday, from: Date())
    
    if let nextWeekday = weekdaySet.integerGreaterThan(weekday) {
    
      return nextWeekday
    
    } else {
    
      return weekdaySet.first!
    }
  } 
}
