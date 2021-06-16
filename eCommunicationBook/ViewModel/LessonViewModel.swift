//
//  LessonViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class LessonViewModel {
    var lesson: Lesson
    
    init(model lesson: Lesson) {
        
        self.lesson = lesson
    }
    
    var number: Int {
        
        return lesson.number
    }
    
    var teacher: String {
        
        return lesson.teacher
    }
    
    var time: Double {
        
        return lesson.time
    }
    
    var timeInterval: Int {
        
        return lesson.timeInterval
    }
    
    var todaysLesson: [String]? {
        
        return lesson.todaysLesson
    }
    
    var tests: [String]? {
    
        return lesson.tests
    }
    
    var assignments: [String]? {
    
        return lesson.assignments
    }
}
