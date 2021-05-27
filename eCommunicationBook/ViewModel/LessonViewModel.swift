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
    get {
      return lesson.number
    }
  }
  
  var teacher: String {
    get {
      return lesson.teacher
    }
  }
  var time: Double {
    get {
      return lesson.time
    }
  }
  
  var timeInterval: Int {
    get {
      return lesson.timeInterval
    }
  }
  var todaysLesson: [String]? {
    get {
      return lesson.todaysLesson
    }
  }
  var tests: [String]? {
    get {
      return lesson.tests
    }
  }
  var assignments: [String]? {
    get {
      return lesson.assignments
    }
  }
  
  
}
