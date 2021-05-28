//
//  LessonPerformancesViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/28.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class LessonPerformancesViewModel {
  
  var studentLessonRecordsViewModel = Box([StudentLessonRecordViewModel]())
  var sectionTitles = ["Lesson Performances"]
  var performancesItem = ["Concentration", "Attidtude", "Participant"]
  
  var studentIndex = 0
  
  var course: Course = Course(
    id: "",
    name: "",
    teachers: [],
    students: [],
    firstLessonDate: -1,
    courseTime: [],
    fee: -1,
    lessonsAmount: -1,
    lessons: nil)
  
  var previousLesson: Lesson = Lesson(
    id: "",
    number: -1,
    teacher: "",
    time: -1,
    timeInterval: -1,
    todaysLesson: nil,
    tests: nil,
    assignments: nil)
  
  var currentLesson: Lesson = Lesson(
    id: "",
    number: -1,
    teacher: "",
    time: -1,
    timeInterval: -1,
    todaysLesson: nil,
    tests: nil,
    assignments: nil)
  
  
  var studentLessonRecord: StudentLessonRecord = StudentLessonRecord (
    id: "",
    studentID: "",
    courseName: "",
    time: -1,
    timeInterval: -1,
    todaysLesson: nil,
    tests: nil,
    assignments: nil,
    performances: [],
    previousTests: nil,
    previousAssignments: nil,
    testGrade: nil,
    assignmentCompleted: nil,
    assignmentScore: nil,
    note: nil)
  
  
  
  
  func onMainCollectionViewScrolled(destination index: Int) {
    updateStudentLessonRecordsViewModel(index: studentIndex)
    studentIndex = index
  }
  
  func updateStudentLessonRecordsViewModel(index: Int) {
    studentLessonRecordsViewModel.value[index] = StudentLessonRecordViewModel(model: studentLessonRecord)
  }
  
  func onPerformanceSliderSlides(index: Int, value: Int) {
    studentLessonRecord.performances[index] = value
  }
  
  func onAssignmentsStatusToggle(index: Int) {
    if !(studentLessonRecord.assignmentCompleted![index]) {
      studentLessonRecord.assignmentCompleted?[index] = false
    } else {
      studentLessonRecord.assignmentCompleted?[index] = true
    }
      
  }
  func onChangeContent(index: Int, text: String) {
    studentLessonRecord.testGrade?[index] = text
  }
  func onCommunicationCorneChanged(text: String) {
    studentLessonRecord.note = text
  }
  func setViewModel() {
    if previousLesson.assignments != nil {
      sectionTitles.append("Homework Status")
    }
    if previousLesson.tests != nil {
      sectionTitles.append("Tests Grade")
    }
    
    sectionTitles.append("Comunication Corner")
    
    studentLessonRecord.courseName = course.name
    studentLessonRecord.time = currentLesson.time
    studentLessonRecord.timeInterval = currentLesson.timeInterval
    studentLessonRecord.todaysLesson = currentLesson.todaysLesson
    studentLessonRecord.tests = currentLesson.tests
    studentLessonRecord.assignments = currentLesson.assignments
    
    studentLessonRecord.performances = performancesItem.map({ _ in -1 })

    if let assignments = previousLesson.assignments {
      studentLessonRecord.assignmentCompleted = assignments.map({ _ in false })
    }
    
    
    if let assignments = previousLesson.assignments {
      studentLessonRecord.previousAssignments = assignments
       studentLessonRecord.assignmentCompleted = assignments.map({ _ in false })
     }
    if let tests = previousLesson.tests {
      studentLessonRecord.tests = tests
      studentLessonRecord.testGrade = tests.map({ _ in "-1" })
     }
    
    
    
    studentLessonRecordsViewModel.value = scaleViewModels(with: self.course)
    
  }

  
  func scaleViewModels(with course: Course) -> [StudentLessonRecordViewModel] {
    
    var viewModels = [StudentLessonRecordViewModel]()
    
    for student in course.students {
      
      studentLessonRecord.studentID = student
      
      let viewModel = StudentLessonRecordViewModel(model: studentLessonRecord)
      
      viewModels.append(viewModel)
    }
    
    return viewModels
  }
}
