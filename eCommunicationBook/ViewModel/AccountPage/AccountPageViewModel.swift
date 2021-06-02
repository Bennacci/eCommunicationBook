//
//  AccountPageViewModel.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import Foundation

struct AccountPageViewModel {
  
  func servicesData() -> ServiceGroup {
    let services = ServiceManager.init(userType: UserType(rawValue: UserManager.shared.user.userType!)!).services
    return services
  }
}
