//
//  AccountManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/18.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ServiceManager {
    
    private let userType: UserType
    
    init(userType: UserType) {
        
        self.userType = userType
    }
    
    var services: ServiceGroup {
        
        switch userType {
        
        case .teacher:
            
            let teacherService = ServiceGroup(
                
                title: [localizedString("學生紀錄："),
                        localizedString("增加事項："),
                        localizedString("系統：")],
                
                items: [
                    
                    [TeacherSeviceItem.writeStudentLessonRecord,
                     
                     TeacherSeviceItem.writeLessonPlan,
                     
                     TeacherSeviceItem.writeStudentTimeInAndOut,
                     
                     TeacherSeviceItem.attendanceSheet],
                    
                    [TeacherSeviceItem.newACourse,
                     
                     TeacherSeviceItem.newEvent,
                     
                     TeacherSeviceItem.setASign,
                     
                     TeacherSeviceItem.newAStudent
                     
                     // hidden for release
                     // TeacherSeviceItem.newAUser
                    ]
                ]
            )
            
            return teacherService
            
        default:
            
            let parentService = ServiceGroup(
                
                title: [localizedString("Learning"),
                        
                        localizedString("Lessons"),
                        
                        localizedString("extras")],
                
                items: [
                    
                    [ParentSeviceItem.signCommunicationBook,
                     
                     ParentSeviceItem.checkStudentTimeInAndOut],
                    []
                    // unfinished services
                    //          [ParentSeviceItem.courseReservation,
                    
                    //           ParentSeviceItem.leaveReservation,
                    
                    //           ParentSeviceItem.makeUpReservation,
                    
                    //           ParentSeviceItem.payTimeAnnounce,
                    
                    //           ParentSeviceItem.newAStudent,
                    
                    //           ParentSeviceItem.contactUs]
                ]
            )
            return parentService
        }
    }
}
