//
//  HomePageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/1.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation



class HomePageViewModel {
  var signViewModel = Box([EventViewModel]())
  
    var servicesData: ServiceGroup? {
        didSet {
            self.onGotUserData?()
        }
    }
    
    var onGotUserData: (() -> Void)?
      
    func checkUser() {
        
        if UserManager.shared.user.id != "" {
            
        XXXManager.shared.identifyUser(uid: UserManager.shared.user.id) { [weak self] result in
          
          switch result {
            
          case .success(let user):
            
            UserManager.shared.user = user
            
            self?.servicesData = ServiceManager.init(userType: UserType(rawValue: UserManager.shared.user.userType!)!).services
                        
          case .failure(let error):

              print("fetchData.failure: \(error)")

          }
        }
      }
    }
    
  func fetchSign() {
    XXXManager.shared.fetchSign { [weak self] result in
      switch result {
        
      case .success(let signs):
        
        self?.setSignViewModel(signs: signs)
        
      //            self?.onCallendarTap()
      case .failure(let error):
        print("fetchData.failure: \(error)")
      }
    }
    
  }
  func convertSignToViewModels(from signs: [Event]) -> [EventViewModel] {
    var viewModels = [EventViewModel]()
    for sign in signs {
      let viewModel = EventViewModel(model: sign)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  func setSignViewModel(signs: [Event]) {
    signViewModel.value = convertSignToViewModels(from: signs)
  }
}
