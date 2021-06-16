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
        
        return event.id
    }
    
    var eventName: String {
        
        return event.eventName
    }
    
    var description: String {
        
        return event.description
    }
    
    var image: String? {
        
        return event.image
    }
    
    var date: Double {
    
        return event.date
    }
    
    var time: Int {
    
        return event.time
    }
    
    var timeInterval: Int {
        
        return event.timeInterval
    }
}
