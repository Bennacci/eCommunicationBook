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
    
    var editContentPageTitle = String.empty
    
    var content = String.empty
    
    var contentLength = String.empty
    
    var onContentSaved: (() -> Void)?
    
    func setUpContent() {
        
        if editContentPageTitle == AccountPageService.displayName.rawValue {
            
            content = UserManager.shared.user.name
            
        } else if editContentPageTitle == AccountPageService.localNumber.rawValue {
            
            content = "\(UserManager.shared.user.homePhoneNo)"
            
        } else if editContentPageTitle == AccountPageService.cellPhoneNumber.rawValue {
            
            content = "\(UserManager.shared.user.cellPhoneNo)"
            
        } else if editContentPageTitle == AccountPageService.email.rawValue {
            
            content = UserManager.shared.user.email
        }
    }
    
    func onContentChanged(with info: String) {
        
        content = info
        
        contentLength = "\(info.count)" + "/ 20"
    }
    
    func ontapSave() {
        
        if editContentPageTitle == AccountPageService.displayName.rawValue {
            
            UserManager.shared.user.name = content
            
        } else if editContentPageTitle == AccountPageService.localNumber.rawValue {
            
            UserManager.shared.user.homePhoneNo = Int(content)!
            
        } else if editContentPageTitle == AccountPageService.cellPhoneNumber.rawValue {
            
            UserManager.shared.user.cellPhoneNo = Int(content)!
            
        } else if editContentPageTitle == AccountPageService.email.rawValue {
            
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
