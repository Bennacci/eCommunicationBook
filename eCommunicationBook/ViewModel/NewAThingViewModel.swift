//
//  SetAThingViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

// 用protocol 拆成 newthing 系列 VM?

//protocol NewAThingViewModel {
//  var inputTexts: [[String]] { get set }
//
//  var inputDates: [[Date]] { get set }
//
//  var servicesItem: AccountItem { get set }
//
//  func loadInitialValues()
//}

class NewAThingViewModel: SearchUserDelegate {
  
  var inputTexts: [[String]] = [[]]
  
  var inputDates: [[Date]] = []
  
  var servicesItem = ServiceManager.init(userType: UserManager.shared.userType).services.items[0][0]
  
  func loadInitialValues() {
    inputTexts = servicesItem.form!
    
    for index in 0..<inputTexts.count {
      let input = Array(repeating: Date(), count: inputTexts[index].count)
      inputDates.append(input)
      //      inputValuse.append(input)
    }
  }
  
//  var searchUserDelegate: SearchUserDelegate?
  
  var onDataUpdated: (() -> Void)?
  
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
    self.onDataUpdated?()
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
  
  func onLessonsAmountChanged(text lessonsAmount: String) {
    self.course.lessonsAmount = Int(lessonsAmount) ?? -1
  }
  
  func onSearchAndSelected() {
    
    
    
    self.course.teacher = UserManager.shared.selectedUsers.map({$0.id})
    
    
    //      with
    print(self.course.teacher)
    onDataUpdated!()
  }
  //  func onTeachersChanged(text name: String) {
  //    self.teacher.name = name
  //  }
  
}
