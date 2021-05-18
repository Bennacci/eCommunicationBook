//
//  AccountPageViewModel.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import Foundation

struct ServiceViewModel {
  
//  let manager =ServiceManager
  let services = ServiceManager.init(userType: UserManager.shared.userType).services
  
  //  var service0: String {
  //    return "學習狀況"
  //  }
  
  //  var service1: String{
  //    switch booking {
  //    case .leaveReservation: return "線上請假"
  //    case .courseReservation: return "課程預約"
  //    default: return "補課申請"
  //    }
  //  }
  
  //    var service2: String{
  //      return "繳費通知"
  //    }
  //
  //    var service3: String{
  //      return "聯絡我們"
  //    }
}
