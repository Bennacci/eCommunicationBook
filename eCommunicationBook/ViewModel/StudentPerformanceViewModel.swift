//
//  StudentPerformanceViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class StudentLessonRecordViewModel {
  
  var studentLessonRecord: StudentLessonRecord
  
  init(model studentLessonRecord: StudentLessonRecord) {
  
    self.studentLessonRecord = studentLessonRecord
  }
  var performancesItem = ["Concentration", "Attidtude", "Participant"]
  var id: String {
    get {
      return studentLessonRecord.id
    }
  }
  
  var studentID: String {
    get {
      return studentLessonRecord.studentID
    }
  }
  
  var courseName: String {
    get {
      return studentLessonRecord.courseName
    }
  }
  
  var time: Double {
    get {
      return studentLessonRecord.time
    }
  }
  
  var timeInterval: Int {
    get {
      return studentLessonRecord.timeInterval
    }
  }
  
  var todaysLesson: [String]? {
    get {
      return studentLessonRecord.todaysLesson
    }
  }
  
  var tests: [String]? {
    get {
      return studentLessonRecord.tests
    }
  }
  
  var assignments: [String]? {
    get {
      return studentLessonRecord.assignments
    }
  }
  
  
  
  var performances: [ClassPerformance.RawValue] {
    get {
      return studentLessonRecord.performances
    }
  }
  
  var previousTests: [String]? {
    get {
      return studentLessonRecord.previousTests
    }
  }
  
  var previousAssignments: [String]? {
    get {
      return studentLessonRecord.previousAssignments
    }
  }
  
  var testGrade: [String]? {
    get {
      return studentLessonRecord.testGrade
    }
  }
  
  var assignmentCompleted: [Bool]? {
    get {
      return studentLessonRecord.assignmentCompleted
    }
  }
  

  var assignmentScore: [Int]? {
    get {
      return studentLessonRecord.assignmentScore
    }
  }
  
  var note: String? {
    get {
      return studentLessonRecord.note
    }
  }
}
