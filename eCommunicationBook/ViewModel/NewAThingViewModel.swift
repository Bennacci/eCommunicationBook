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
// }

class NewAThingViewModel: SearchUserDelegate {
  
  let eventViewModel = Box([EventViewModel]())
  
  var inputTexts: [[String]] = [[]]
  
  var inputDates: [[Date]] = []
  
  var servicesItem = ServiceManager.init(userType: UserManager.shared.userType).services.items[0][0]
  
  func loadInitialValues() {
    
    guard let form = servicesItem.form else {return}
    
    inputTexts = form
    
    for index in 0..<inputTexts.count {
      let input = Array(repeating: Date(), count: inputTexts[index].count)
      inputDates.append(input)
      //      inputValuse.append(input)
    }
    self.onFirstLessonDateChanged(day: Date())
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
  
  func onTapAdd(thing: String) {
    if thing == "Create User"{
      self.addUser(with: &user)
    } else if thing == "Create Class"{
      self.addCourse(with: &course)
    } else if thing == "Create Event"{
      self.addEvent(with: &event)
    } else if thing == "Create Sign"{
      self.addSign(with: &event)
    }
    UserManager.shared.selectedUsers = []
    UserManager.shared.selectedUsersTwo = []
    UserManager.shared.selectedDays = nil
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
    self.course.fee = Int(fee) ?? -99
  }
  func onCourseTimeChanged(time: [RoutineHour]) {
    self.course.courseTime = time
  }
  
  func onLessonsAmountChanged(text lessonsAmount: String) {
    self.course.lessonsAmount = Int(lessonsAmount) ?? -1
  }
  
  func onSearchAndSelected(secondTime: Bool) {
    if secondTime == false {
      guard let selectedUsers = UserManager.shared.selectedUsers else {return}
      self.course.teacher = selectedUsers.map({$0.id})
    } else {
      guard let selectedUsersTwo = UserManager.shared.selectedUsersTwo else {return}
      self.course.student = selectedUsersTwo.map({$0.id})
    }
    onDataUpdated!()
  }
  
  func addCourse (with course: inout Course) {
    XXXManager.shared.addCourse(course: &course) { result in
      
      switch result {
        
      case .success:
        
        print("onTapAdd, success")
        self.onAdded?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
  //  func onTeachersChanged(text name: String) {
  //    self.teacher.name = name
  //  }
  
  var event: Event = Event(id: "",
                           eventName: "",
                           description: "",
                           image: nil,
                           date: -1,
                           time: 0,
                           timeInterval: 0)
  
  func onEventNameChanged(text eventName: String) {
    self.event.eventName = eventName
  }
  
  func onEventDiscriptionChanged(text description: String) {
    self.event.description = description
  }
  
  func onEventDateChanged(day: Date) {
    self.event.date = Double(day.millisecondsSince1970)
  }
  
  func onEventTimeChanged(time: RoutineHour) {
    
    self.event.time = time.startingTime
    
    self.event.timeInterval = time.timeInterval
  }
  func addEvent (with event: inout Event) {
    XXXManager.shared.addEvent(event: &event) { result in
      
      switch result {
        
      case .success:
        
        print("onTapAdd, success")
        self.onAdded?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
  func addSign (with sign: inout Event) {
    XXXManager.shared.addSign(sign: &sign) { result in
      
      switch result {
        
      case .success:
        
        print("onTapAdd, success")
        self.onAdded?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
}
