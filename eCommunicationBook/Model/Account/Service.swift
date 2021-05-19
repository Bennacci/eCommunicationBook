//
//  ServiceProvider.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/18.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

struct ServiceGroup {

    let title: [String]

//    let action: ServiceSegue?

    let items: [[AccountItem]]
}

// enum ServiceSegue: String {
//
//    case segueAllOrder = "AllOrder"
//
//    var title: String {
//
//        switch self {
//
//        case .segueAllOrder: return localizedString("查看全部")
//
//        }
//    }
// }

protocol AccountItem {
  
  var image: UIImage? { get }
  
  var title: String { get }
}

enum ParentSeviceItem: AccountItem {

  case checkLearingStat
  
  case payTimeAnnounce
  
  case contactUs
  
  case leaveReservation
  
  case courseReservation
  
  case makeUpReservation
  
  var image: UIImage? {
    switch self {

    case .checkLearingStat: return UIImage.asset(.Bear)
      
    case .payTimeAnnounce: return UIImage.asset(.Bear)
      
    case .contactUs: return UIImage.asset(.Bear)
      
    case .leaveReservation: return UIImage.asset(.Bear)
      
    case .courseReservation: return UIImage.asset(.Bear)
      
    case .makeUpReservation: return UIImage.asset(.Bear)
    }
  }
  
  var title: String {
    switch self {

    case .checkLearingStat: return localizedString("學習狀況")
      
    case .payTimeAnnounce: return localizedString("繳費通知")
      
    case .contactUs: return localizedString("聯絡我們")
      
    case .leaveReservation: return localizedString("線上請假")
      
    case .courseReservation: return localizedString("課程預約")
      
    case .makeUpReservation: return localizedString("補課申請")
    }
  }
}

enum TeacherSeviceItem: AccountItem {
  
  case newAClass
  
  case newEvent
  
  case setASign
  
  case writeAttendAndLeave
  
  case writeLessonState
  //
  var image: UIImage? {
    
    switch self {
    
    case .newAClass: return UIImage.asset(.Bear)
      
    case .newEvent: return UIImage.asset(.Bear)
      
    case .setASign: return UIImage.asset(.Bear)
      
    case .writeAttendAndLeave: return UIImage.asset(.Bear)
      
    case .writeLessonState: return UIImage.asset(.Bear)
    //
    }
  }
  
  var title: String {
    
    switch self {
    
    case .newAClass: return localizedString("開課")
      
    case .newEvent: return localizedString("新增活動")
      
    case .setASign: return localizedString("新增公告")
      
    case .writeAttendAndLeave: return localizedString("出離席紀錄")
      
    case .writeLessonState: return localizedString("學生上課狀況")
    }
  }
}
