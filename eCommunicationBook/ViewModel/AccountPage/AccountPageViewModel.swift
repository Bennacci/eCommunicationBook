//
//  AccountPageViewModel.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import Foundation

struct AccountPageViewModel {
  
  func servicesData() -> ServiceGroup {
    let services = ServiceManager.init(userType: UserManager.shared.userType).services
    return services
  }
}
