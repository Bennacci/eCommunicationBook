////
////  SearchStudentViewModel.swift
////  eCommunicationBook
////
////  Created by Ben Tee on 2021/5/25.
////  Copyright © 2021 TKY co. All rights reserved.
////
//
//import Foundation
//
//class SearchStudentPageViewModel {
//
//  let studentViewModel = Box([StudentViewModel]())
//
//  let userListViewModel = Box([StudentViewModel]())
//
//  var refreshView: (()->())?
//
//  var scrollToTop: (()->())?
//
//  var tapUser: (()->())?
//
//  var secondTime = false
//
//
//
//
//  func fetchData() {
//
//    XXXManager.shared.fetchStudents { [weak self] result in
//
//      switch result {
//
//      case .success(let students):
//
//        self?.setSearchResult(students)
//
//      case .failure(let error):
//
//        print("fetchData.failure: \(error)")
//      }
//    }
//  }
//
//  func onSendAndQuit() {
//    if secondTime == false {
//      UserManager.shared.selectedUsers = userListViewModel.value
//    } else {
//      UserManager.shared.selectedUsersTwo = userListViewModel.value
//    }
//  }
//
//  func addUserToList(user: UserViewModel) {
//    setUserSelected(user)
//    //    self.tapUser?()
//  }
//
//  func removeUserFromList(user: UserViewModel) {
//
//    setUserDeselected(user)
//
//  }
//
//  func onRefresh() {
//    // maybe do something
//    self.refreshView?()
//  }
//  
//  func onScrollToTop() {
//
//    self.scrollToTop?()
//  }
//
//  func onTap(withIndex index: Int) {
//    //        chatRoomViewModel.value[index].onTap()
//  }
//
//  func convertUserToViewModels(from students: [Student]) -> [StudentViewModel] {
//    var viewModels = [StudentViewModel]()
//    for student in students {
//      let viewModel = StudentViewModel(model: student)
//      viewModels.append(viewModel)
//    }
//    return viewModels
//  }
//
//  func setSearchResult(_ students: [Student]) {
//    studentViewModel.value = convertUserToViewModels(from: students)
//
//
//    if secondTime == false {
//      userListViewModel.value = UserManager.shared.selectedUsers ?? []
//    } else {
//      userListViewModel.value = UserManager.shared.selectedUsersTwo ?? []
//    }
//  }
//
//
//  func addUserToViewModels(with user: UserViewModel) -> [UserViewModel] {
//    var viewModels = userListViewModel.value
//    viewModels.append(user)
//
//    return viewModels
//  }
//
//  func setUserSelected(_ user: UserViewModel) {
//    userListViewModel.value = addUserToViewModels(with: user)
//  }
//
//  func removeUsefromViewModels(with user: UserViewModel) -> [UserViewModel] {
//    let oldViewModels = userListViewModel.value
//    var newViewModels = [UserViewModel]()
//    newViewModels = oldViewModels.filter({$0.id != user.id})
//    return newViewModels
//  }
//
//  func setUserDeselected(_ user: UserViewModel) {
//    userListViewModel.value = removeUsefromViewModels(with: user)
//  }
//}
