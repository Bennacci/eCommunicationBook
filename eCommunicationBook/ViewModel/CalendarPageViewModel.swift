//
//  CalendarPageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class CalendarPageViewModel {
  
  let eventViewModel = Box([EventViewModel]())
  
  let studentPerformancesViewModel = Box([StudentLessonRecordViewModel]())
  
  var refreshView: (() -> Void)?
  
  var scrollToTop: (() -> Void)?
  
  var dayEventViewModel = Box([EventViewModel]())
  
  var dayPerformanceViewModel = Box([StudentLessonRecordViewModel]())
  
  func onRefresh() {
    // maybe do something
    self.refreshView?()
  }
  
  func onScrollToTop() {
    
    self.scrollToTop?()
  }
  
  // GCD and tapped in future
  
  func onCalendarTapped(day: Date) {
    
    let time = Double(day.millisecondsSince1970)
    
    let secondsPerDay = Double(CalendarHelper.shared.secondsPerDay)
    
    dayEventViewModel.value = eventViewModel.value.filter({
      
        $0.date >= time &&
        
        $0.date <= time + secondsPerDay * 1000 - 1
      
    })
    
    dayPerformanceViewModel.value = studentPerformancesViewModel.value.filter({
      
        $0.time >= time &&
        
        $0.time <= time + secondsPerDay * 1000 - 1
    })
//    print(day)
//    print("123")
//    print(dayEventViewModel)
  }
  
  func fetchData() {
    //
    XXXManager.shared.fetchEvents { [weak self] result in
      
      switch result {
        
      case .success(let events):
        
        self?.setEvents(events)
                
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
    
    XXXManager.shared.fetchStudentPerformances { [weak self] result in
      
      switch result {
        
      case .success(let studentPerformances):
        
        self?.setStudentPerformances(studentPerformances)
        
//        self?.onCalendarTapped(day: Date())

      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
  func convertEventsToViewModels(from events: [Event]) -> [EventViewModel] {
    var viewModels = [EventViewModel]()
    for event in events {
      let viewModel = EventViewModel(model: event)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  func setEvents(_ events: [Event]) {
    eventViewModel.value = convertEventsToViewModels(from: events)
  }
  
  func convertStudenPerformancesToViewModels(from performances: [StudentLessonRecord]) -> [StudentLessonRecordViewModel] {
    var viewModels = [StudentLessonRecordViewModel]()
    for performance in performances {
      let viewModel = StudentLessonRecordViewModel(model: performance)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  func setStudentPerformances(_ performances: [StudentLessonRecord]) {
    studentPerformancesViewModel.value = convertStudenPerformancesToViewModels(from: performances)
  }
}
