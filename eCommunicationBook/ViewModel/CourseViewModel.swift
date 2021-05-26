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
  init(model course: Course){
    self.course = course
  }
  
  var id: String {
    get {
      return course.id
    }
  }
  
  var name: String {
    get {
      return course.name
    }
  }
  var teacher: [String] {
    get {
      return course.teacher
    }
  }
  var student: [String] {
    get {
      return course.student
    }
  }
  var firstLessonDate: Double {
    get {
      return course.firstLessonDate
    }
  }
  var courseTime: [RoutineHour] {
    get {
      return course.courseTime
    }
  }
  var fee: Int {
    get {
      return course.fee
    }
  }
  var lessonsAmount: Int {
    get {
      return course.lessonsAmount
    }
  }
  var lessons: [Lesson]? {
    get {
      return course.lessons
    }
  }
  
  
}
