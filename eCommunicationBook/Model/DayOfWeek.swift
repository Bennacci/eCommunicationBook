//
//  DayOfWeek.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

enum DayOfWeek: Int {
  case sunday = 1
  case monday = 2
  case tuesday = 3
  case wendnesday = 4
  case thrusday = 5
  case friday = 6
  case saturday = 7
}

class CalendarHelper {
  
  static let shared = CalendarHelper()
  
  let secondsPerDay: Int = (24 * 60 * 60)
  
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
  /**
   Convert a date to a enumeration member
   */
  func day(from date: Date) -> DayOfWeek {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "e"
    
    let dayNumber: Int = Int(formatter.string(from: date))!
    
    return DayOfWeek(rawValue: dayNumber)!
  }
  /**
   Calculate the `TimeInterval` between days contained
   in user preferences.
   
   - Parameter days: Period selected by user
   - Returns: Interval between dates days
   */
  func calculatePattern(withDays days: [DayOfWeek]) -> [TimeInterval] {
    var pattern: [TimeInterval] = [TimeInterval]()
    
    for (index, day) in days.enumerated() {
      let distance: Int = (index == (days.count - 1)) ?
        (7 - (day.rawValue - days[0].rawValue)) : days[index + 1].rawValue - day.rawValue
      
      let interval: TimeInterval = TimeInterval(secondsPerDay * distance)
      
      pattern.append(interval)
    }
    
    return pattern
  }
  
  func nextDay(from days: [DayOfWeek]) -> DayOfWeek {
    let today: DayOfWeek = day(from: Date())
  
    let restDays = days.filter({ $0.rawValue > today.rawValue })
  
    return restDays.first!
  }
}
