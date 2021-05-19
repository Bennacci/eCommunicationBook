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

    var userList: [User] = []
  
    var refreshView: (()->())?
    
    var scrollToTop: (()->())?
    
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
    
  func addUserToList(user: User) -> [User]{
   
    userList.append(user)
    
    return userList
  }
  
  func removeUserFromList(index: Int) -> [User]{
    
    userList.remove(at: index)
    
    return userList
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
    }
}
