//
//  TimeSelectionViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/23.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

protocol TimeSelectionDelegate: AnyObject {
    
    func didSelectTime(for thing: String)
}

class TimeSelectionViewModel {

    var onAdded: (() -> Void)?

    var inputText: [String] = ["Day", "Starting Time", "Time Interval", "Delete"]
    
    var inputTexts: [[String]] = [["Day", "Starting Time", "Time Interval", "Delete"]]
    
    var inputTextsForEvent = ["Starting Time", "Time Interval"]
    
    weak var delegate: TimeSelectionDelegate?
    
    var forEvent = false
    
    var overed = false
    
    var onDataUpdated: (() -> Void)?
    
    func loadInitialValues() {
    
        for _ in 0 ..< routineHours.count {
        
            inputTexts.append(inputText)
        }
    }
    
    func onSendAndQuit() {
        
        UserManager.shared.selectedDays = routineHours
    }
    
    func onAddorDeleteADay(day: Int) {
        
        if day == inputTexts.count - 1 {
            
            inputTexts.append(self.inputText)
            
            routineHours.append(RoutineHour(
                                    day: 1,
                                    startingTime: 0,
                                    timeInterval: 0))
        
        } else {
        
            inputTexts.remove(at: day)
            
            routineHours.remove(at: day)
        }
        
        self.onDataUpdated?()
    }
    
    var routineHours: [RoutineHour] = [RoutineHour(
                                        day: 1,
                                        startingTime: 0,
                                        timeInterval: 0)]
    
    func onDayChanged(index: Int, day: Int) {
     
        self.routineHours[index].day = day
        
        self.onDataUpdated?()
    }
    
    func onStartingTimeChanged(index: Int, hourInput: String) {
        
        let hourInt: Int? = Int(hourInput)
        
        let startingTime = self.routineHours[index].startingTime
        
        if let hour = hourInt, hour <= 24 {
            
            self.routineHours[index].startingTime = startingTime % 100 + hour * 100
        
            overed = false
        
        } else {
        
            self.routineHours[index].startingTime = startingTime % 100
            
            overed = true
        }
    }
    
    func onStartingTimeChanged(index: Int, minuteInput: String) {
      
        let minuteInt: Int? = Int(minuteInput)
        
        let startingHour = self.routineHours[index].startingTime / 100
        
        if let min = minuteInt, min < 60 && overed == false {
        
            if startingHour == 24 {
            
                self.routineHours[index].startingTime = min
            
            } else {
            
                self.routineHours[index].startingTime = startingHour * 100 + min
            }
            
        } else {
            
            self.routineHours[index].startingTime = 0
        }
        
        self.onDataUpdated?()
    }
    
    func onTimeIntervalChanged(index: Int, hourInput: String) {
        
        let hourInt: Int? = Int(hourInput)
        
        let timeInterval = self.routineHours[index].timeInterval
        
        if let hour = hourInt {
        
            self.routineHours[index].timeInterval = timeInterval % 60 + hour * 60
        }
    }
    
    func onTimeIntervalChanged(index: Int, minuteInput: String) {
        
        let minInt: Int? = Int(minuteInput)
        
        let timeInterval = self.routineHours[index].timeInterval
        
        if let min = minInt {
        
            if min < 60 {
            
                self.routineHours[index].timeInterval = timeInterval - timeInterval % 60 + min
            
            } else {
            
                self.routineHours[index].timeInterval = timeInterval - timeInterval % 60
            }
        }
        
        self.onDataUpdated?()
    }
}
