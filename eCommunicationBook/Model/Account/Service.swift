//
//  ServiceProvider.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/18.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

enum UserType: String, CaseIterable {
  case teacher
  
  case parents
}

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
  
  var formTitle: String? { get }
  
  var form: [[String]]? { get }
  
}

enum ParentSeviceItem: AccountItem {
  
  case checkLearingStat
  
  case payTimeAnnounce
  
  case leaveReservation
  
  case courseReservation
  
  case makeUpReservation
  
  case newAStudent
  
  case contactUs
  
  var image: UIImage? {
    switch self {
      
    case .checkLearingStat: return UIImage.asset(.Bear)
      
    case .payTimeAnnounce: return UIImage.asset(.Bear)
      
    case .leaveReservation: return UIImage.asset(.Bear)
      
    case .courseReservation: return UIImage.asset(.Bear)
      
    case .makeUpReservation: return UIImage.asset(.Bear)
      
    case .newAStudent: return UIImage.asset(.Bear)
      
    case .contactUs: return UIImage.asset(.Bear)
    }
  }
  
  var title: String {
    switch self {
      
    case .checkLearingStat: return localizedString("學習狀況")
      
    case .payTimeAnnounce: return localizedString("繳費通知")
      
    case .leaveReservation: return localizedString("線上請假")
      
    case .courseReservation: return localizedString("課程預約")
      
    case .makeUpReservation: return localizedString("補課申請")
      
    case .newAStudent: return localizedString("新增孩童資料")
      
    case .contactUs: return localizedString("聯絡我們")
      
    }
  }
  
  var formTitle: String? {
    switch self {
    case .newAStudent: return "Children Informations"
      
    case .checkLearingStat,
         
         .payTimeAnnounce,
         
         .leaveReservation,
         
         .courseReservation,
         
         .makeUpReservation,
         
         .contactUs: return nil
    }
  }
  
  var form: [[String]]? {
    switch self {
    case .newAStudent: return [["Name", "National ID"],
                               ["Birth Date"],
                               ["Grade"],
                               ["Emergency Contact Person", "Contact Number"],
                               ["image"]]
      
    case .checkLearingStat,
         
         .payTimeAnnounce,
         
         .leaveReservation,
         
         .courseReservation,
         
         .makeUpReservation,
         
         .contactUs: return nil
    }
  }
}

enum TeacherSeviceItem: AccountItem {
  
  case writeAttendAndLeave
  
  case writeLessonState
  
  case newEvent
  
  case setASign
  
  case newACourse
  
  case newAStudent
  
  case newAUser
  
  
  //
  var image: UIImage? {
    
    switch self {
      
    case .writeAttendAndLeave: return UIImage.asset(.Bear)
      
    case .writeLessonState: return UIImage.asset(.Bear)
      
    case .newEvent: return UIImage.asset(.Bear)
      
    case .setASign: return UIImage.asset(.Bear)
      
    case .newACourse: return UIImage.asset(.Bear)
      
    case .newAStudent : return UIImage.asset(.Bear)
      
    case .newAUser: return UIImage.asset(.Bear)
      
    }
  }
  
  var title: String {
    
    switch self {
      
    case .writeAttendAndLeave: return localizedString("出離席紀錄")
      
    case .writeLessonState: return localizedString("學生上課狀況")
      
    case .newEvent: return localizedString("新增活動")
      
    case .setASign: return localizedString("新增公告")
      
    case .newACourse: return localizedString("開課")
      
    case .newAStudent : return localizedString("新增孩童資料")
      
    case .newAUser: return localizedString("新增用戶")
      
      
      
    }
  }
  var formTitle: String? {
    switch self {
      
      
      
    case .newEvent: return "Create Event"
      
    case .setASign: return "Create Sign"
      
    case .newACourse: return "Create Class"
      
    case .newAStudent: return "Children Informations"
      
    case .newAUser: return "Create User"
      
    default:
      return nil
    }
  }
  
  var form: [[String]]? {
    switch self {
      
    case .newEvent: return [["Title"], ["Date", "Time"], ["Description"]]
      
    case .setASign: return [["Title"], ["Date", "Time"], ["Description"]]
      
    case .newACourse: return [["Class Name"],
                              ["Teachers", "Students"],
                              ["First Lesson Date", "Lesson Schedule", "Total Lessons Count"],
                              [ "Fee"]]
      
    case .newAStudent: return [["Name", "National ID"],
                               ["Birth Date"],
                               ["Grade"],
                               ["Emergency Contact Person", "Contact Number"],
                               ["image"]]
      
    case .newAUser: return [["Name", "ID", "User Type"],
                            ["Birth Date"],
                            ["E-mail", "CellPhone Number", "Contact Number"],
                            ["image"]]
      
    default:
      return nil
    }
    //    var viewModel: NewAThingViewModel{
    //      switch self {
    //      case .newAUser: return NewAUserModel
    //
    //      default:
    //
    //      }
    //    }
  }
}
