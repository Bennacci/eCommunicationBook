//
//  SignInPageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/2.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class SignInPageViewModel {
  
  var userType = UserType.allCases
  
  var onGotUserData: (() -> Void)?
  
  var onUserCreated: (() -> Void)?
  
  var onFailure: (() -> Void)?
  
  func onUserTypeChange(type: Int) {
    if type == 0 {
      UserManager.shared.user.userType = UserType.parents.rawValue
    } else {
      UserManager.shared.user.userType = UserType.teacher.rawValue
    }
  }
  
  func signInUser() {
    
    XXXManager.shared.identifyUser(uid: UserManager.shared.user.id) { [weak self] result in
      
      switch result {
        
      case .success(let user):
        
        UserManager.shared.user = user
        
        self?.onGotUserData?()
        
      case .failure(let error):

        switch error {
        case MasterError.noMatchData("User not found"):
          self?.createUser()
        default:
          self?.onFailure?()
          print("fetchData.failure: \(error)")
        }
      }
    }
  }
  
  func createUser() {
    XXXManager.shared.addUser(user: &UserManager.shared.user) { [weak self] result in
      
      switch result {
        
      case .success( _):
        
        self?.onUserCreated?()
        
      case .failure(let error):
        
        self?.onFailure?()
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
  func updateUserType() {
    XXXManager.shared.addUser(user: &UserManager.shared.user) { [weak self] result in
      
      switch result {
        
      case .success( _):
        
        self?.onGotUserData?()
        
      case .failure(let error):
        
        self?.onFailure?()
        
        print("fetchData.failure: \(error)")
      }
    }
  }
}
