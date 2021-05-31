//
//  HomePageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/1.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class HomePageViewModel {
  
    func servicesData() -> ServiceGroup {
    let services = ServiceManager.init(userType: UserManager.shared.userType).services
    return services
  }
  
}