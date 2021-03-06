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
    
    let items: [[AccountItem]]
}

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
        
        case .signCommunicationBook: return UIImage(systemName: "book")
            
        case .checkStudentTimeInAndOut: return UIImage(systemName: "person.crop.square")
            
        case .checkLearingStat: return UIImage(systemName: "doc.append")
            
        case .payTimeAnnounce: return UIImage(systemName: "alarm")
            
        case .leaveReservation: return UIImage(systemName: "calendar.circle")
            
        case .courseReservation: return UIImage(systemName: "calendar.circle")
            
        case .makeUpReservation: return UIImage(systemName: "calendar.circle")
            
        case .newAStudent: return UIImage(systemName: "person.crop.circle.badge.plus")
            
        case .contactUs: return UIImage(systemName: "envelope.circle")
        }
    }
    
    var title: String {
        
        switch self {
        
        case .signCommunicationBook: return localizedString("Communication Book")
            
        case .checkStudentTimeInAndOut: return localizedString("Time In / Out")
            
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
        
        case .newAStudent: return "Student Info"
            
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
    
    var image: UIImage? {
        
        switch self {
        
        case .attendanceSheet: return UIImage(systemName: "timer")
            
        case .writeStudentTimeInAndOut: return UIImage(systemName: "qrcode.viewfinder")
            
        case .writeLessonPlan:  return UIImage(systemName: "square.and.pencil")
            
        case .writeStudentLessonRecord: return UIImage(systemName: "book")
        
        case .newEvent: return UIImage(systemName: "calendar.badge.plus")
            
        case .setASign: return UIImage(systemName: "calendar.badge.plus")
            
        case .newACourse: return UIImage(systemName: "calendar.badge.plus")
            
        case .newAStudent : return UIImage(systemName: "person.crop.circle.badge.plus")
            
        case .newAUser: return UIImage(systemName: "person.crop.circle.badge.plus")
        }
    }
    
    var title: String {
        
        switch self {
        
        case .attendanceSheet: return localizedString("Attendance Sheet")
            
        case .writeStudentTimeInAndOut: return localizedString("Student Time In / Out")
            
        case .writeLessonPlan: return localizedString("Lesson Plan")
            
        case .writeStudentLessonRecord: return localizedString("Communication Book")
            
        case .newEvent: return localizedString("Event")
            
        case .setASign: return localizedString("News")
            
        case .newACourse: return localizedString("New Course")
            
        case .newAStudent : return localizedString("New Student")
            
        case .newAUser: return localizedString("Create User")
        }
    }
    
    var formTitle: String? {
        
        switch self {
        
        case .newEvent: return "Create Event"
            
        case .setASign: return "Create News"
            
        case .newACourse: return "Create Class"
            
        case .newAStudent: return "Student Info"
            
        case .newAUser: return "Create User"
            
        default:
            
            return nil
        }
    }
    
    var form: [[String]]? {
        
        switch self {
        
        case .newEvent: return [["Title"], ["Date"], ["Time"], ["Description"]]
            
        case .setASign: return [["Title"], ["Date"], ["Time"], ["Description"]]
            
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
    }
}
