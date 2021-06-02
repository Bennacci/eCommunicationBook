//
//  SearchUserVIewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class UserViewModel: SearchUserPageMaterial {
  
  var user: User
  
  var onDead: (() -> Void)?
  
  init(model user: User) {
    self.user = user
  }
  
  var id: String {
    get {
      return user.id
    }
  }
  
  var userID: String {
    get {
      return user.userID
    }
  }
  var name: String {
    get {
      return user.name
    }
  }
  var image: String? {
    get {
      return user.image
    }
  }
  var cellPhoneNo: Int {
    get {
      return user.cellPhoneNo
    }
  }
  var homePhoneNo: Int {
    get {
      return user.homePhoneNo
    }
  }
  var birthDay: Double {
    get {
      return user.birthDay
    }
  }
  var email: String {
    get {
      return user.email
    }
  }
  var userType: UserType.RawValue? {
    get {
      return user.userType
    }
  }
  var workingHours: [RoutineHour]? {
    get {
      return user.workingHours
    }
  }
  var difficulty: [Int]? {
    get {
      return user.difficulty
    }
  }
  var note: [String]? {
    get {
      return user.note
    }
  }
  
  func onTap() {
    
    //    sendArrays
    
    //    XXXManager.shared.conversationID = chatRoom.id
    //    conversationViewModel.setConversations(chatRoom.messages!)
    //      XXXManager.shared.deleteArticle(article: chatRoom) { [weak self] result in
    //
    //          switch result {
    //
    //          case .success(let articleId):
    //
    //              print(articleId)
    //              self?.onDead?()
    //
    //          case .failure(let error):
    //
    //              print("publishArticle.failure: \(error)")
    //          }
    //      }
  }
}
