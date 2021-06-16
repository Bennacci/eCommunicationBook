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
    
        return user.id
    }
    
    var userID: String {
        
        return user.userID
    }
    
    var name: String {
    
        return user.name
    }
    
    var image: String? {
    
        return user.image
    }
    
    var cellPhoneNo: Int {
    
        return user.cellPhoneNo
    }
    
    var homePhoneNo: Int {
    
        return user.homePhoneNo
    }
    
    var birthDay: Double {
    
        return user.birthDay
    }
    
    var email: String {
    
        return user.email
    }
    
    var userType: UserType.RawValue? {
    
        return user.userType
    }
    
    var workingHours: [RoutineHour]? {
    
        return user.workingHours
    }
    
    var difficulty: [Int]? {
    
        return user.difficulty
    }
    
    var note: [String]? {
    
        return user.note
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
