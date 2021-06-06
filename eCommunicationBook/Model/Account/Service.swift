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
  
    case parents
  
    case teacher
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
  
  case signCommunicationBook
  
  case checkStudentTimeInAndOut
  
  case checkLearingStat
  
  case payTimeAnnounce
  
  case leaveReservation
  
  case courseReservation
  
  case makeUpReservation
  
  case newAStudent
  
  case contactUs
  
  var image: UIImage? {
    switch self {
    
    case .signCommunicationBook: return UIImage(systemName: "doc.append")
      
    case .checkStudentTimeInAndOut: return UIImage(systemName: "person.crop.square")
      
    case .checkLearingStat: return UIImage.asset(.Performances)
      
    case .payTimeAnnounce: return UIImage.asset(.Pay)
      
    case .leaveReservation: return UIImage.asset(.Event)
      
    case .courseReservation: return UIImage.asset(.Event)
      
    case .makeUpReservation: return UIImage.asset(.Event)
      
    case .newAStudent: return UIImage.asset(.Children)
      
    case .contactUs: return UIImage.asset(.ContactUs)
    }
  }
  
  var title: String {
    switch self {
    
    case .signCommunicationBook: return localizedString("Communication Book")
    
    case .checkStudentTimeInAndOut: return localizedString("Attendance")
      
    case .checkLearingStat: return localizedString("Learning Status")
      
    case .payTimeAnnounce: return localizedString("Payment Notice")
      
    case .leaveReservation: return localizedString("Leave Reservation")
      
    case .courseReservation: return localizedString("Lesson Reservation")
      
    case .makeUpReservation: return localizedString("Make Up Lesson Reservation")
      
    case .newAStudent: return localizedString("Create Student Information")
      
    case .contactUs: return localizedString("Contact Us")
      
    }
  }
  
  var formTitle: String? {
    switch self {
    case .newAStudent: return "Children Informations"
      
    case .signCommunicationBook,
         
         .checkStudentTimeInAndOut,
     
         .checkLearingStat,
         
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
      
    case .signCommunicationBook,
         
         .checkStudentTimeInAndOut,
     
         .checkLearingStat,
         
         .payTimeAnnounce,
         
         .leaveReservation,
         
         .courseReservation,
         
         .makeUpReservation,
         
         .contactUs: return nil
    }
  }
}

enum TeacherSeviceItem: AccountItem {
  
  case writeStudentTimeInAndOut
 
  case attendanceSheet
  
  case writeLessonPlan

  case writeStudentLessonRecord
  
  case newEvent
  
  case setASign
  
  case newACourse
  
  case newAStudent
  
  case newAUser
  
  
  //
  var image: UIImage? {
    
    switch self {
      
    case .attendanceSheet: return UIImage(systemName: "timer")
      
    case .writeStudentTimeInAndOut: return UIImage(systemName: "qrcode.viewfinder")
      
    case .writeLessonPlan:  return UIImage(systemName: "square.and.pencil")
    
    case .writeStudentLessonRecord: return UIImage(systemName: "book")
      
    case .newEvent: return UIImage(systemName: "calendar.badge.plus")
      
    case .setASign: return UIImage.asset(.Sign)
      
    case .newACourse: return UIImage.asset(.CreateCourse)
      
    case .newAStudent : return UIImage.asset(.Children)
      
    case .newAUser: return UIImage(systemName: "person.crop.badge.plus")
      
    }
  }
  
  var title: String {
    
    switch self {
      
    case .attendanceSheet: return localizedString("Attendance Sheet")

    case .writeStudentTimeInAndOut: return localizedString("Student Time In / Out")
    
    case .writeLessonPlan: return localizedString("Lesson Plan")
      
    case .writeStudentLessonRecord: return localizedString("Communication Book")
      
    case .newEvent: return localizedString("New Event")
      
    case .setASign: return localizedString("New Sign")
      
    case .newACourse: return localizedString("New Course")
      
    case .newAStudent : return localizedString("New Student")
      
    case .newAUser: return localizedString("Create User")
      
      
      
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
