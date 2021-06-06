//
//  AccountPageViewModel.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import UIKit

class AccountPageViewModel {
  
  var onImageUploaded: (() -> Void)?
  
  func servicesData() -> ServiceGroup {
    let services = ServiceManager.init(userType: UserType(rawValue: UserManager.shared.user.userType!)!).services
    return services
  }
  
  func accountPageItem() -> [[String]] {
    var services = [[String]]()
//    if UserManager.shared.user.userType == UserType.parents.rawValue {
//      services = [["Display name", "Set profile icon"],
//                  ["Local number", "Cell phone number", "Email"],
//                  ["Birthday"]]
//    } else {
      services = [["Display name", "Set profile icon"],
                  ["Local number", "Cell phone number", "Email"],
                  ["Birthday"]]
//    }
    return services
  }
  
  func uploadImage(with image: UIImage) {
    
    XXXManager.shared.uploadPickerImage(pickerImage: image) { result in
      
      switch result {
        
      case .success(let imageUrl):
        
        self.onImageUploaded(url: imageUrl)
        print("Publish Image Succeeded")

      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
      }
    }
  }
  
  func onImageUploaded(url: String) {
    
    UserManager.shared.user.image = url
    
    XXXManager.shared.addUser(user: &UserManager.shared.user) { [weak self] result in
      
      switch result {
        
      case .success( _):
        
        self?.onImageUploaded?()
        
      case .failure(let error):
        
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
}
