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
//    let formatter: DateFormatter = DateFormatter()
//    formatter.dateFormat = "e"
//
//    let dayNumber: Int = Int(formatter.string(from: date))!
    
    let calendar = Calendar.current
    let weekday =  calendar.component(.weekday, from: date)
    
    
    return DayOfWeek(rawValue: weekday)!
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
  
  
  func nextDate(baseDate: Date, daySet: IndexSet) -> Double {
  // Put your weekday indexes in an `IndexSet`
  let weekdaySet = daySet
//    IndexSet([1, 2, 4, 7]) // Sun, Mon, Wed and Sat
  // Get the current calendar and the weekday from today
  let calendar = Calendar.current
  var weekday =  calendar.component(.weekday, from: baseDate)

  // Calculate the next index
  if let nextWeekday = weekdaySet.integerGreaterThan(weekday) {
      weekday = nextWeekday
  } else {
      weekday = weekdaySet.first!
  }

  // Get the next day matching this weekday
  let components = DateComponents(weekday: weekday)
    let nextDate = calendar.nextDate(after: baseDate, matching: components, matchingPolicy: .nextTime)
    guard let nextDateDouble = nextDate?.timeIntervalSince1970 else { return -1 }
    return nextDateDouble
  }
//
//  func nextDay(date: Date, daysSet: [Int]) -> Date {
//
//
//    let day: DayOfWeek = self.day(from: date)
//
//    guard let restDays = daysSet.filter({ $0 > day.rawValue })
//      else {
//        return days.first!
//    }
//    return days.first!
//  }
  
  func nextDay(from days: [DayOfWeek]) -> DayOfWeek {
    let today: DayOfWeek = day(from: Date())
  
    let restDays = days.filter({ $0.rawValue > today.rawValue })
  
    return restDays.first!
  }
}
