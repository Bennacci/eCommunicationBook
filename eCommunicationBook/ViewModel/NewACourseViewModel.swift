////
////  NewAUserViewModel.swift
////  eCommunicationBook
////
////  Created by Ben Tee on 2021/5/22.
////  Copyright © 2021 TKY co. All rights reserved.
////
//
//import Foundation
//
//class NewACourseViewModel: NewAThingViewModel, SearchUserDelegate {
//  var inputTexts: [[String]] = [[]]
//
//  var inputDates: [[Date]] = []
//
//  var servicesItem: AccountItem = ServiceManager.init(userType: UserManager.shared.userType).services.items[0][0]
//
//  func loadInitialValues() {
//    inputTexts = servicesItem.form!
//
//    for index in 0..<inputTexts.count {
//      let input = Array(repeating: Date(), count: inputTexts[index].count)
//        inputDates.append(input)
//      //      inputValuse.append(input)
//    }
//  }
//
//  // MARK: - new a class
//
//  var course: Course = Course(
//    id: "",
//    name: "",
//    teacher: [],
//    student: [],
//    firstLessonDate: -1,
//    courseTime: [],
//    fee: -1,
//    lessonsAmount: -1,
//    lessons: nil)
//
//  func onCourseNameChanged(text name: String) {
//    self.course.name = name
//  }
//
//  func onFirstLessonDateChanged(day: Date) {
//    self.course.firstLessonDate = Double(day.millisecondsSince1970)
//  }
//
//  func onFeeChanged(text fee: String) {
//    self.course.fee = Int(fee) ?? -1
//  }
//
//  func onLessonsAmountChanged(text fee: String) {
//    self.course.fee = Int(fee) ?? -1
//  }
//  func onSearchAndSelected(with: [UserViewModel]) {
//    self.course.teacher = with.map({$0.id})
//  }
//  //  func onTeachersChanged(text name: String) {
//  //    self.teacher.name = name
//  //  }
//
//}
