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
  
  var onAdded: (() -> Void)?
  
  func onTapAdd(thing: String) {
    if thing == "Children Informations"{
      self.addStudent(with: &student)
    } else if thing == "Create User" {
      self.addUser(with: &user)
    } else if thing == "Create Class"{
      self.addCourse(with: &course)
    } else if thing == "Create Event"{
      self.addEvent(with: &event)
    } else if thing == "Create Sign"{
      self.addSign(with: &event)
    }
    UserManager.shared.selectedUsers = []
    UserManager.shared.selectedStudents = []
    UserManager.shared.selectedDays = nil
  }
  
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
    lessons: [])
  
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
  
  func onSearchAndSelected(forStudent: Bool) {
    if forStudent == false {
      guard let selectedUsers = UserManager.shared.selectedUsers else {return}
      self.course.teacher = selectedUsers.map({$0.userID})
    } else {
      guard let selectedUsersTwo = UserManager.shared.selectedStudents else {return}
      self.course.student = selectedUsersTwo.map({$0.id})
    }
    onDataUpdated!()
  }
  
  func addCourse (with course: inout Course) {
    
    var lessons: [Lesson] = []
    
    var lessonTime = course.firstLessonDate
    var day : DayOfWeek
    let days = course.courseTime.map({$0.day})
    
    for index in  0 ..< course.lessonsAmount {
      
      day = CalendarHelper.shared.day(from: Date(timeIntervalSince1970: lessonTime))
      let courseTime = course.courseTime.filter({$0.day == day.rawValue}).first ?? course.courseTime[0]
      
      lessonTime += Double(courseTime.startingTime / 100 * 60 * 60 * 1000)
      lessonTime += Double(courseTime.startingTime % 100 * 60 * 1000)
      
      let lesson = Lesson(number: index, teacher: "", time: lessonTime, timeInterval: course.courseTime[0].timeInterval, todaysLesson: nil, tests: nil, assignments: nil)
      
      let nextLessonTime = CalendarHelper.shared.nextDate(baseDate: Date(milliseconds: course.firstLessonDate), daySet: IndexSet(days))
      
      lessons.append(lesson)
      
      lessonTime = nextLessonTime
      
    }
    course.lessons = lessons
        
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
  
   // MARK: - new a Event and sign
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

  // MARK: - new a Student
  var student: Student = Student(id: "",
                                 parents: [],
                                 name: "",
                                 image: nil,
                                 nationalID: "",
                                 grade: 0,
                                 birthDay: -1,
                                 emergencyContactPerson: "",
                                 emergencyContactNo: -1)
  
  func onStudentNameChanged(text name: String) {
    self.student.name = name
  }
  
  func onStudentNationalIDChanged(text nationalID: String) {
    self.student.nationalID = nationalID
  }
  
  func onStudentGradeChanged(text grade: String) {
    self.student.grade = Int(grade) ?? -1
  }
  func onStudentBirthDayChanged(day: Date) {
    self.student.birthDay = Double(day.millisecondsSince1970)
  }
  func onStudentContactPersonChanged(text person: String) {
    self.student.emergencyContactPerson = person
  }
  func onStudentContactNoChanged(text contactNo: String) {
    self.student.emergencyContactNo = Int(contactNo) ?? -1
  }
  
  func addStudent (with student: inout Student) {
    XXXManager.shared.addStudent(student: &student) { result in
      
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
