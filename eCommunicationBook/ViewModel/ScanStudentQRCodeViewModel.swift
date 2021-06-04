//
//  ScanStudentQRCodeViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/30.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ScanStudentQRCodeViewModel {
  
  var courseViewModel = Box([CourseViewModel]())
  
  var lessonList = [String]()
  
  var lessonListChanged: (()->Void)?
  
  var timeIn: Bool = true {
    didSet {
      studentExistance.studentName = ""
    }
  }
  
  var studentExistance = StudentExistance(
    id: "",
    studentID: "",
    studentName: "",
    time: -1,
    latitude: -1,
    longitude: -1,
    courseName: "",
    courseLesson: 0,
    scanTeacherName: "")
  
  func onScanedAQRCode(info: String) {
    
    let lines = info.components(separatedBy: "\n")
    
//    let qrCodeInfo = info.split(whereSeparator: \.isNewline)
    if lines.count >= 2 {
      if  studentExistance.studentName != lines[0] {
        studentExistance.studentName = lines[0]
        studentExistance.studentID = lines[1]
        if timeIn == true {
          writeTimeIn(with: &studentExistance)
        } else {
          writeTimeOut(with: &studentExistance)
        }
      }
    }
  }
  
  func onCourseNameChanged(index: Int) {
    studentExistance.courseName = courseViewModel.value[index].name
    setLessonList(index: index)
  }
  
  func setLessonList(index: Int?) {
    lessonList.removeAll()
    if let index = index {
    for index in 0 ..< courseViewModel.value[index].lessonsAmount {
      lessonList.append(String(index + 1))
      }
    }
    self.lessonListChanged?()
  }
  
  func onCourseLessonChanged(index: Int) {
    studentExistance.courseLesson = index + 1
  }
  
  
  func onCurrentLocationChanged(latitude: Double, longitude: Double) {
    studentExistance.latitude = latitude
    studentExistance.longitude = longitude
  }
  
  var wroteInSuccess: (() -> Void)?
  
  //  var wroteInFailure: (() -> Void)?
  
  var wroteOutSuccess: (() -> Void)?
  
  //  var wroteOutFailure: (() -> Void)?
  
  func writeTimeIn(with studentExistance: inout StudentExistance) {
  
    LKProgressHUD.show()

    XXXManager.shared.writeTimeIn(studentExistance: &studentExistance) { result in
     
      LKProgressHUD.dismiss()

      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        
        self.wroteInSuccess?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
        
        //        self.wroteInFailure?()
      }
    }
  }
  func writeTimeOut(with studentExistance: inout StudentExistance) {
    
    LKProgressHUD.show()

    XXXManager.shared.writeTimeOut(studentExistance: &studentExistance) { result in
      
      LKProgressHUD.dismiss()

      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        
        self.wroteOutSuccess?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
        
        //        self.wroteOutFailure?()
        
      }
    }
  }
  
    
  func fetchCourse() {
    XXXManager.shared.fetchCourses { [weak self] result in
      
      switch result {
        
      case .success(let courses):
        
        self?.setSearchResult(courses)
        
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
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
      print(courses)
  //    if let uID = UserManager.shared.userID {
  ////    courseViewModel.value = convertCoursesToViewModels(from: courses).filter { $0.teacher.contains(uID) }
  //
  //    }
      courseViewModel.value = convertCoursesToViewModels(from: courses)

    }
    
}
