//
//  AccountPageViewModel.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import UIKit

enum AccountPageService: String {
    case displayName = "Display name"
    case setProfileIcon = "Set profile icon"
    case localNumber = "Local number"
    case cellPhoneNumber = "Cell phone number"
    case email = "Email"
    case birthday = "Birthday"
}

class AccountPageViewModel {
  
  var onImageUploaded: (() -> Void)?
  
  func servicesData() -> ServiceGroup {
    
    let services = ServiceManager.init(userType: UserType(rawValue: UserManager.shared.user.userType!)!).services
    
    return services
  }
  
  func accountPageItem() -> [[String]] {
    
    var services = [[String]]()

    services = [[AccountPageService.displayName.rawValue,
                 AccountPageService.setProfileIcon.rawValue],
                [AccountPageService.localNumber.rawValue,
                 AccountPageService.cellPhoneNumber.rawValue,
                 AccountPageService.email.rawValue],
                [AccountPageService.birthday.rawValue]]
    
    return services
  }
  
  func uploadImage(with image: UIImage) {
    
    ImageManager.shared.uploadPickerImage(pickerImage: image) { result in
      
      switch result {
        
      case .success(let imageUrl):
        
        self.onImageUploaded(url: imageUrl)
        
        print("Publish Image Succeeded")

      case .failure(let error):
        
        print("uploadImage.failure: \(error)")
      }
    }
  }
  
  func onImageUploaded(url: String) {
    
    UserManager.shared.user.image = url
    
    UserManager.shared.addUser(user: &UserManager.shared.user) { [weak self] result in
      
      switch result {
        
      case .success( _):
        
        self?.onImageUploaded?()
        
      case .failure(let error):
        
        print("addUser.failure: \(error)")
      }
    }
  }
}
