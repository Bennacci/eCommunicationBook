//
//  LessonPlanViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation



class LessonPlanDetailViewModel {

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
    time: -1, timeInterval: -1,
    todaysLesson: nil,
    tests: nil,
    assignments: nil)
  
  var lesson: Lesson = Lesson(
    id: "",
    number: -1,
    teacher: "",
    time: -1, timeInterval: -1,
    todaysLesson: nil,
    tests: nil,
    assignments: nil)
  
  //  func
  
  
  //  func onContentChange(indexPath: IndexPath, text content: String) {
  //    lesson.onChangeContent(indexPath: indexPath, text: content)
  //
  //  }
  //
  //  func onTapColumn(indexPath: IndexPath) {
  //    lessonViewModels.value[0].modColumn(indexPath: indexPath)
  //  }
  //
  //  func onDeleteColumn(indexPath: IndexPath){
  //    viewModel?.deleteColumn(indexPath: indexPath)
  //  }
  var lessonChanged: (()->Void)?
  
  var onSaved: (()->Void)?
  
  func onSave() {
    self.save(with: &lesson)
  }
  
  func save(with lesson: inout Lesson) {
    XXXManager.shared.saveLesson(lesson: &lesson) { result in
      
      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        self.onSaved?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
  
  func onLessonChanged() {
    self.lessonChanged?()
  }
  
  func onChangeContent(indexPath: IndexPath, text content: String) {
    
    switch indexPath.section {
    case 0:
      self.lesson.todaysLesson?[indexPath.row] = content
    case 1:
      self.lesson.assignments?[indexPath.row] = content
    default:
      self.lesson.tests?[indexPath.row] = content
    }
    self.onLessonChanged()
  }
  
  func onDelColumn(indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      self.lesson.todaysLesson?.remove(at: indexPath.row)
    case 1:
      self.lesson.assignments?.remove(at: indexPath.row)
    default:
      self.lesson.tests?.remove(at: indexPath.row)
    }
    self.onLessonChanged()
  }
  
  func onModColumn(indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      
      if let todaysLessons = lesson.todaysLesson {
        if todaysLessons.count == indexPath.row {
          self.lesson.todaysLesson?.append("")
        } else {
          return
        }
      } else {
        self.lesson.todaysLesson = [""]
      }
      
    case 1:
      if let assignments = lesson.assignments {
        if assignments.count == indexPath.row {
          self.lesson.assignments?.append("")
        } else {
          return
        }
      } else {
        self.lesson.assignments = [""]
      }
      
    default:
      if let tests = lesson.tests {
        if tests.count == indexPath.row {
          self.lesson.tests?.append("")
        } else {
          return
        }
      } else {
        self.lesson.tests = [""]
      }
    }
    self.onLessonChanged()
  }
}
