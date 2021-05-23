//
//  SearchUserPageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class SearchUserPageViewModel {
  
  let userViewModel = Box([UserViewModel]())
  
  let userListViewModel = Box([UserViewModel]())
  
  var refreshView: (()->())?
  
  var scrollToTop: (()->())?
  
  var tapUser: (()->())?
  
  lazy var secondTime = false
  
  func fetchData() {
    
    XXXManager.shared.fetchUser { [weak self] result in
      
      switch result {
        
      case .success(let users):
        
        self?.setSearchResult(users)
        
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
  func onSendAndQuit() {
    if secondTime == false {
      UserManager.shared.selectedUsers = userListViewModel.value
    } else {
      UserManager.shared.selectedUsersTwo = userListViewModel.value
      secondTime = false
    }
  }
  
  func addUserToList(user: UserViewModel) {
    setUserSelected(user)
    //    self.tapUser?()
  }
  
  func removeUserFromList(user: UserViewModel) {
    
    setUserDeselected(user)
    
  }
  
  func onRefresh() {
    // maybe do something
    self.refreshView?()
  }
  
  func onScrollToTop() {
    
    self.scrollToTop?()
  }
  
  func onTap(withIndex index: Int) {
    //        chatRoomViewModel.value[index].onTap()
  }
  
  func convertUserToViewModels(from users: [User]) -> [UserViewModel] {
    var viewModels = [UserViewModel]()
    for user in users {
      let viewModel = UserViewModel(model: user)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  func setSearchResult(_ users: [User]) {
    userViewModel.value = convertUserToViewModels(from: users)

    
    if secondTime == false {
      userListViewModel.value = UserManager.shared.selectedUsers
    } else {
      userListViewModel.value = UserManager.shared.selectedUsersTwo
    }
  }
  
  
  func addUserToViewModels(with user: UserViewModel) -> [UserViewModel] {
    var viewModels = userListViewModel.value
    viewModels.append(user)
    
    return viewModels
  }
  
  func setUserSelected(_ user: UserViewModel) {
    userListViewModel.value = addUserToViewModels(with: user)
  }
  
  func removeUsefromViewModels(with user: UserViewModel) -> [UserViewModel] {
    let oldViewModels = userListViewModel.value
    var newViewModels = [UserViewModel]()
    newViewModels = oldViewModels.filter({$0.id != user.id})
    return newViewModels
  }
  
  func setUserDeselected(_ user: UserViewModel) {
    userListViewModel.value = removeUsefromViewModels(with: user)
  }
}
