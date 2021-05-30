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
  
  var onSaved: (() -> Void)?

  func onSave() {
    
    self.studentLessonRecordsViewModel.value[studentIndex] =
    StudentLessonRecordViewModel(model: self.studentLessonRecord)
    
    for index in 0 ..< studentLessonRecordsViewModel.value.count {
      self.save(with: &studentLessonRecordsViewModel.value[index].studentLessonRecord)
    }
  }
  
  func save(with studentLessonRecord: inout StudentLessonRecord) {
    XXXManager.shared.saveStudentLessonRecord(studentLessonRecord: &studentLessonRecord) { result in
      
      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        self.onSaved?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
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
  
  var studentLessonRecord: StudentLessonRecord = StudentLessonRecord(
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

  func onMainCollectionViewInnerScrolled() {
    self.studentLessonRecordsViewModel.value[studentIndex] =
      StudentLessonRecordViewModel(model: self.studentLessonRecord)
  }

  func onMainCollectionViewScrolled(destination index: Int) {
    updateStudentLessonRecordsViewModel(index: index)
  }
  
  func updateStudentLessonRecordsViewModel(index: Int) {
    let serialQueue = DispatchQueue(label: "scrollItem")
    serialQueue.sync {
//        print("Task 1")
//      print(index)
//    print(studentLessonRecord)
//      print(studentIndex)
      self.studentLessonRecordsViewModel.value[studentIndex] =
        StudentLessonRecordViewModel(model: self.studentLessonRecord)
    }
    serialQueue.sync {
    studentLessonRecord = self.studentLessonRecordsViewModel.value[index].studentLessonRecord
    studentIndex = index

    }
  }
  
  func onPerformanceSliderSlides(index: Int, value: Int) {
//    studentLessonRecordsViewModel.value[index/1000].performances[index%1000] = value
    studentLessonRecord.performances[index] = value
  }
  
  func onAssignmentsStatusToggle(index: Int) {
    if (studentLessonRecord.assignmentCompleted?[index])! {
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
      
    studentLessonRecord.performances = performancesItem.map({ _ in 3 })

    if let assignments = previousLesson.assignments {
      studentLessonRecord.assignmentCompleted = assignments.map({ _ in false })
    }
    
    if let assignments = previousLesson.assignments {
      studentLessonRecord.previousAssignments = assignments
       studentLessonRecord.assignmentCompleted = assignments.map({ _ in false })
     }
    if let tests = previousLesson.tests {
      studentLessonRecord.previousTests = tests
      studentLessonRecord.testGrade = tests.map({ _ in "" })
     }
    
    studentLessonRecord.note = ""

    studentLessonRecordsViewModel.value = scaleViewModels(with: self.course)
    
    studentLessonRecord = studentLessonRecordsViewModel.value[0].studentLessonRecord
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
