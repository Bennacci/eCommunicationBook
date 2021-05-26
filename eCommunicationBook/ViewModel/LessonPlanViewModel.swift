//
//  LessonPlanViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class LessonPlanViewModel {
  
  var courseViewModel = Box([CourseViewModel]())
  
  var lessonViewModel = Box([LessonViewModel]())
  
  var refreshView: (()->())?

  
  func fetchData() {
    XXXManager.shared.fetchCourses { [weak self] result in
      
      switch result {
        
      case .success(let courses):
        
        self?.setSearchResult(courses)
        
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
//  func onRefresh() {
//    // maybe do something
//    self.refreshView?()
//  }
  
  func convertCoursesToViewModels(from courses: [Course]) -> [CourseViewModel] {
    var viewModels = [CourseViewModel]()
    for course in courses {
      let viewModel = CourseViewModel(model: course)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  
  func setSearchResult(_ courses: [Course]) {
    if let uID = UserManager.shared.userID {
    courseViewModel.value = convertCoursesToViewModels(from: courses).filter { $0.teacher.contains(uID) }
    }
  }
  
  
  
  func convertLessonsToViewModels(from lessons: [Lesson]) -> [LessonViewModel] {
    var viewModels = [LessonViewModel]()
    for lesson in lessons {
      let viewModel = LessonViewModel(model: lesson)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  func setLessonViewModel(index: Int) {
    if let lessons = courseViewModel.value[index].lessons {
    lessonViewModel.value = convertLessonsToViewModels(from: lessons)
    }
  }
  
}


