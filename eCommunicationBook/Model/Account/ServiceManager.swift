//
//  AccountManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/18.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
//
//class ServiceProvider {
//
//  enum ClientType {
//
//    case teacher
//
//    case parents
//  }
//
//  private let clientType: ClientType
//
//  init(clientType: ClientType) {
//
//    self.clientType = clientType
//  }
// }
class ServiceManager {
  
  private let userType: UserType
  
  init(userType: UserType) {
    
    self.userType = userType
  }
  
  var services: ServiceGroup {
    
    switch userType {
      
    case .teacher:
      
      let teacherService = ServiceGroup(
       
         title: [localizedString("增加事項："),
           
                 localizedString("學生紀錄：")],
      
         items: [
           
          [TeacherSeviceItem.newAUser],
            
            [TeacherSeviceItem.newAClass,
            
            TeacherSeviceItem.newEvent,
           
            TeacherSeviceItem.setASign],
           
           [TeacherSeviceItem.writeAttendAndLeave,
         
            TeacherSeviceItem.writeLessonState
           ]
         ]
       )
      return teacherService
      
    default:
      
      let parentService = ServiceGroup(
        
        title: [localizedString("學習"),
                
                localizedString("課程"),
          
                localizedString("校方")],
        items: [
          
          [ParentSeviceItem.checkLearingStat],
          
          [ParentSeviceItem.courseReservation,
          
           ParentSeviceItem.leaveReservation,
        
           ParentSeviceItem.makeUpReservation],
          
          [ParentSeviceItem.contactUs]
        ]
      )
      return parentService
    }
  }
}
