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
  
  var refreshView: (() -> Void)?
  
  var onStudentAdded: (() -> Void)?

  func fetchData() {
    
    LessonManager.shared.fetchCourses { [weak self] result in
      
      switch result {
        
      case .success(let courses):
        
        self?.setSearchResult(courses)
        
      case .failure(let error):
        
        print("fetchCourses.failure: \(error)")
      }
    }
  }
  
  func onVerifyInvitationCode(code: String) {
    
    XXXManager.shared.identifyStudent(id: code) { [weak self] result in
      
      switch result {
      
      case .success(let student):

        BTProgressHUD.dismiss()

        if UserManager.shared.user.student == nil {

          UserManager.shared.user.student = [student]

        } else if UserManager.shared.user.student!.filter({$0.id == student.id}).count == 0 {

          UserManager.shared.user.student?.append(student)
          
        } else {
          
          BTProgressHUD.dismiss()
          
          BTProgressHUD.showFailure(text: "Invalid invitation code")
        }

        UserManager.shared.addUser(user: &UserManager.shared.user) { [weak self] result in
          
          switch result {
            
          case .success( _):
            
            BTProgressHUD.dismiss()

            BTProgressHUD.showSuccess(text: "Successffuly Added")

            self?.onStudentAdded?()

          case .failure(let error):
            
            BTProgressHUD.dismiss()
            
            BTProgressHUD.showFailure(text: "Invalid invitation code")
            
            print("addUser.failure: \(error)")
          }
        }

      case .failure(let error):
        
        BTProgressHUD.dismiss()
        
        BTProgressHUD.showFailure(text: "Invalid invitation code")
        
        print("identifyStudent.failure: \(error)")
      }
    }
  }
  
  func convertCoursesToViewModels(from courses: [Course]) -> [CourseViewModel] {
    
    var viewModels = [CourseViewModel]()
    
    for course in courses {
    
        let viewModel = CourseViewModel(model: course)
      
        viewModels.append(viewModel)
    }
    
    return viewModels
  }
  
  func setSearchResult(_ courses: [Course]) {
    
    courseViewModel.value = convertCoursesToViewModels(from: courses)
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
    
    print("index:\(index)")
    
    if let lessons = courseViewModel.value[index].lessons {
    
        lessonViewModel.value = convertLessonsToViewModels(from: lessons)
    }
    
    LessonManager.shared.courseID = courseViewModel.value[index].id
  }
}
