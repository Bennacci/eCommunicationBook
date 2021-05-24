//
//  StudentPerformanceViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class StudentPerformanceViewModel {
  
  var studentPerformance: StudentPerformance
  
  init(model studentPerformance: StudentPerformance) {
  
    self.studentPerformance = studentPerformance
  }

  
  var id: String {
    get {
      return studentPerformance.id
    }
  }
  var date: Double {
    get{
      return studentPerformance.date
    }
  }
  var courseName: String {
    get {
      return studentPerformance.courseName
    }
  }

  var courseTime: RoutineHour {
    get {
      return studentPerformance.courseTime
    }
  }
  
  var attendTime: Double {
    get {
      return studentPerformance.attendTime
    }
  }
  
  var leftTime: Double {
    get {
      return studentPerformance.leftTime
    }
  }
  
  var performance: [ClassPerformance.RawValue] {
    get {
      return studentPerformance.performance
    }
  }
  
  var testGrade: [Int]? {
    get {
      return studentPerformance.testGrade
    }
  }
  
  var assignmentCompleted: [Bool]? {
    get {
      return studentPerformance.assignmentCompleted
    }
  }
  

  var assignmentScore: [Int]? {
    get {
      return studentPerformance.assignmentScore
    }
  }
  
  var note: String? {
    get {
      return studentPerformance.note
    }
  }
}
