//
//  AccountEditContentViewModel.swift
//
//
//  Created by Ben Tee on 2021/6/6.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class AccountEditContentViewModel {
  
  var textFieldTag = -1

  var editContentPageTitle = ""
  
  var content = ""
  
  var contentLength = ""
  
  var onContentSaved: (() -> Void)?
  
  func setUpContent() {
    if editContentPageTitle == "Display name" {
      content = UserManager.shared.user.name
    } else if editContentPageTitle == "Local number" {
      content = "\(UserManager.shared.user.homePhoneNo)"
    } else if editContentPageTitle == "Cell phone number" {
      content = "\(UserManager.shared.user.cellPhoneNo)"
    } else if editContentPageTitle == "Email" {
      content = UserManager.shared.user.email
    }
  }
  
  func onContentChanged(with info: String) {
    content = info
    contentLength = "\(info.count)" + "/ 20"
  }
  
  func ontapSave() {
    if editContentPageTitle == "Display name" {
      UserManager.shared.user.name = content
    } else if editContentPageTitle == "Local number" {
      UserManager.shared.user.homePhoneNo = Int(content)!
    } else if editContentPageTitle == "Cell phone number" {
      UserManager.shared.user.cellPhoneNo = Int(content)!
    } else if editContentPageTitle == "Email" {
      UserManager.shared.user.email = content
    }
    
    UserManager.shared.addUser(user: &UserManager.shared.user) { [weak self] result in
      
      switch result {
        
      case .success( _):
        
        self?.onContentSaved?()
        
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
  }
}
