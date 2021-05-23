//
//  TimeSelectionViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/23.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
//protocol TimeSelectionDelegate {
//  func didSelectTime()
//}


class TimeSelectionViewModel {
  
//  var dayCount: Int = 1
  
  var inputTexts: [[String]] = [["Day", "Starting Time", "Time Interval"]]
  
//  var delegate: TimeSelectionDelegate?
  
//  func loadInitialValues() {
//
//  }
  var dayIndex: Int = 0
  
  var overed = false
  
  var onDataUpdated: (() -> Void)?
  
  
  var routineHouers: [RoutineHour] = [RoutineHour(
    day: 1,
    startingTime: -1,
    timeInterval: -1)]
  
  func onDayChanged(day: Int) {
    self.routineHouers[dayIndex].day = day
        self.onDataUpdated?()
  }
  
  func onStartingTimeChanged(index: Int, hourInput: String) {
    let hourInt: Int? = Int(hourInput)
    let startingTime = self.routineHouers[index].startingTime
    if let hour = hourInt, hour <= 24 {
      self.routineHouers[index].startingTime = startingTime % 100 + hour * 100
      overed = false
    } else {
      self.routineHouers[index].startingTime = startingTime % 100
      overed = true
    }
//    self.onDataUpdated?()
  }
  
  func onStartingTimeChanged(index: Int, minuteInput: String) {
    let minuteInt: Int? = Int(minuteInput)
    let startingHour = self.routineHouers[index].startingTime / 100
    if let min = minuteInt, min < 60 && overed == false {
      self.routineHouers[index].startingTime = startingHour * 100 + min
    } else {
      self.routineHouers[index].startingTime = 0
    }
    self.onDataUpdated?()
  }
  
  func onTimeIntervalChanged(index: Int, timeInterval: Int) {
    self.routineHouers[index].timeInterval = timeInterval
    self.onDataUpdated?()
  }
  
  
  var onAdded: (() -> Void)?
  
//  func onTapAdd() {
////    self.addUser(with: &user)
//  }
}
