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
  
  var servicesItem = ServiceManager.init(userType: UserType(rawValue: UserManager.shared.user.userType!)!).services.items[0][0]
  
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
    student: nil,
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
    teachers: [],
    students: [],
    firstLessonDate: -1,
    courseTime: [],
    fee: -1,
    lessonsAmount: -1,
    lessons: [],
    image: "")
  
  func onCourseNameChanged(text name: String) {
    self.course.name = name
  }
  
  func onFirstLessonDateChanged(day: Date) {
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: day)) else { return }
    self.course.firstLessonDate = Double(date.millisecondsSince1970)
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
      self.course.teachers = selectedUsers.map({$0.name + ":" + $0.userID})
    } else {
      guard let selectedUsersTwo = UserManager.shared.selectedStudents else {return}
      self.course.students = selectedUsersTwo.map({$0.name + ":" + $0.id})
    }
    onDataUpdated!()
  }
  
  func addCourse (with course: inout Course) {
    
    XXXManager.shared.addCourse(course: &course) { result in
      
      switch result {
        
      case .success:
        
        print("onTapAdd, success")
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
    
    self.addLesson(with: &course)
  }
  
  func addLesson (with course: inout Course) {
    
    var lessons: [Lesson] = []
    
    var lessonTime = course.firstLessonDate
    
    var lessonTimes: [RoutineHour] = []
    for index in 0 ..< course.lessonsAmount {
      lessonTimes.append(course.courseTime[index % course.courseTime.count])
    }
    
    for index in  0 ..< course.lessonsAmount {
      
      var lesson = Lesson(id: "",
                          number: -1,
                          teacher: "",
                          time: 0,
                          timeInterval: -1,
                          todaysLesson: nil,
                          tests: nil,
                          assignments: nil)
      
      lesson.number = index + 1
      lesson.teacher = course.teachers[index % course.teachers.count]
      
      if index != 0 {
        let today = lessonTimes[index].day
        let previousDay = lessonTimes[index - 1].day
        if today - previousDay > 0 {
          lesson.time = lessonTime + Double(today - previousDay) * CalendarHelper.shared.secondsPerDay * 1000
        } else {
          lesson.time = lessonTime + Double(today - previousDay + 7) * CalendarHelper.shared.secondsPerDay * 1000
        }
        lessonTime = lesson.time
      } else {
        lesson.time = lessonTime
      }
      
      lesson.time += Double(lessonTimes[index].startingTime / 100 * 60 * 60 * 1000)
      lesson.time += Double(lessonTimes[index].startingTime % 100 * 60 * 1000)
      
      lesson.timeInterval = lessonTimes[index].timeInterval
      print(lesson)
      lessons.append(lesson)
      
    }
    course.lessons = lessons
    
    XXXManager.shared.addLesson(course: &course) { result in
      
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
                           date: Double(Date().millisecondsSince1970),
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
