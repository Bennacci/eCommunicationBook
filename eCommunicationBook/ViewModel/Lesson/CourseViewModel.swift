//
//  CourseViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class CourseViewModel {
    
    var course: Course
    
    init(model course: Course) {
    
        self.course = course
    }
    
    var id: String {
        
        return course.id
    }
    
    var name: String {
    
        return course.name
    }
    
    var teachers: [String] {
    
        return course.teachers
    }
    
    var students: [String] {
    
        return course.students
    }
    
    var firstLessonDate: Double {
    
        return course.firstLessonDate
    }
    
    var courseTime: [RoutineHour] {
    
        return course.courseTime
    }
    
    var fee: Int {
    
        return course.fee
    }
    
    var lessonsAmount: Int {
    
        return course.lessonsAmount
    }
    
    var lessons: [Lesson]? {
        
        return course.lessons
    }
    
    var image: String? {
        
        return course.image
    }
}
