//
//  SetAThingViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

// 用protocol 拆成 newthing 系列 VM?

class NewAThingViewModel: SearchUserDelegate {

  
  
//  var searchUserVIewModel = SearchUserPageViewModel()
  
// MARK: - new a user
  var user: User = User(
    id: "",
    createdTime: -1,
    userID: "",
    name: "",
    image: nil,
    cellPhoneNo: -1,
    homePhoneNo: -1,
    birthDay: -1,
    email: "",
    userType: "",
    workingHours: nil,
    difficulty: nil,
    note: nil)
  
  func onUserIDChanged(text userID: String) {
    self.user.userID = userID
  }
  
  func onNameChanged(text name: String) {
    self.user.name = name
  }
  
  func onCellPhoneNoChanged(text cellPhoneNo: String) {
    self.user.cellPhoneNo = Int(cellPhoneNo) ?? -1
  }
  
  func onHomePhoneNoChanged(text homePhoneNo: String) {
    self.user.homePhoneNo = Int(homePhoneNo) ?? -1
  }
  func onBirthDayChanged(day: Date) {
    self.user.birthDay = Double(day.millisecondsSince1970)
  }
  func onEmailChanged(text email: String) {
    self.user.email = email
  }
  func onUserTypeChanged(text userType: String) {
    self.user.userType = userType
  }
  
  var onAdded: (() -> Void)?
  
  func onTapAdd() {
    self.addUser(with: &user)
  }
  
  func addUser (with user: inout User) {
    XXXManager.shared.addUser(user: &user) { result in
      
      switch result {
        
      case .success:
        
        print("onTapAdd, success")
        self.onAdded?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
// MARK: - new a class

  var course: Course = Course(
    id: "",
    name: "",
    teacher: [],
    student: [],
    firstLessonDate: -1,
    courseTime: [],
    fee: -1,
    lessonsAmount: -1,
    lessons: nil)

  func onCourseNameChanged(text name: String) {
    self.course.name = name
  }
  
  func onFirstLessonDateChanged(day: Date) {
    self.course.firstLessonDate = Double(day.millisecondsSince1970)
  }
  
  func onFeeChanged(text fee: String) {
    self.course.fee = Int(fee) ?? -1
  }
  
  func onLessonsAmountChanged(text fee: String) {
    self.course.fee = Int(fee) ?? -1
  }
  func onSearchAndSelected(with: [UserViewModel]) {
    self.course.teacher = with.map({$0.id})
  }
//  func onTeachersChanged(text name: String) {
//    self.teacher.name = name
//  }

}
