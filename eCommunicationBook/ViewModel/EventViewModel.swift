//
//  CalendarViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class EventViewModel {
  
  var event: Event
  
  init(model event: Event) {
  
    self.event = event

  }
  
  var id: String {
    get {
      return event.id
    }
  }
  
  var eventName: String {
    get {
      return event.eventName
    }
  }
  var description: String {
    get {
      return event.description
    }
  }
  
  var image: String? {
    get {
      return event.image
    }
  }
  var date: Double {
    get {
      return event.date
    }
  }
  var time: Int {
    get {
      return event.time
    }
  }
  
  var timeInterval: Int {
    get {
      return event.timeInterval
    }
  }
}

