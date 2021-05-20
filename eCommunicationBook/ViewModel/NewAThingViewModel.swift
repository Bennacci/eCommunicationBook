//
//  SetAThingViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class NewAThingViewModel {
  
  var user: User = User(
    id: "",
    userID: "",
    name: "",
    image: nil,
    cellPhoneNo: -1,
    homePhoneNo: -1,
    birthDay: -1,
    email: "",
    userType: "",
    workingHours: nil,
    dificulty: nil,
    note: nil)
  
  func onIDChanged(text id: String) {
    self.user.id = id
  }
  
  func onUserIDChanged(text userID: String) {
    self.user.userID = userID
  }
  
  func onNameChanged(text name: String) {
    self.user.name = name
  }
  
  func onCellPhoneNoChanged(text cellPhoneNo: Int) {
    self.user.cellPhoneNo = cellPhoneNo
  }
  
  func onHomePhoneNoChanged(text homePhoneNo: Int) {
    self.user.homePhoneNo = homePhoneNo
  }
  func onBirthDayChanged(text birthDay: Double) {
    self.user.birthDay = birthDay
  }
  func onEmailChanged(text email: String) {
    self.user.email = email
  }
  func onUserTypeChanged(text userType: String) {
    self.user.userType = userType
  }
  
  
  var onPublished: (()->())?
  
//  func onTapPublish() {
//    
//    if hasAuthorInArticle() {
//      print("has author in article...")
//      publish() // MARK: check which function this call is
//      
//    } else {
//      print("login...")
//      UserManager.shared.login() { [weak self] result in
//        // MARK: - put your id into login function
//        switch result {
//          
//        case .success(let author):
//          
//          print("login success")
//          self?.publish(with: author) // MARK: check which function this call is
//          
//        case .failure(let error):
//          
//          print("login.failure: \(error)")
//        }
//        
//      }
//    }
//  }
//  
//  func publish(with article: inout Article) {
//    XXXManager.shared.publishArticle(article: &article) { result in
//      
//      switch result {
//        
//      case .success:
//        
//        print("onTapPublish, success")
//        self.onPublished?()
//        
//      case .failure(let error):
//        
//        print("publishArticle.failure: \(error)")
//      }
//    }
//  }
//  
//  func publish(with author: Author? = nil) {
//    
//    if let author = author {
//      article.author = author
//    }
//    
//    publish(with: &article) // MARK: check which function this call is
//  }
//  
//  func hasAuthorInArticle() -> Bool {
//    return article.author != nil
//  }
}
