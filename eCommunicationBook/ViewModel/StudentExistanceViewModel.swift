//
//  StudentExistanceViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/30.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class StudentExistanceViewModel {
    
    var studentExistance: StudentExistance
    
    // var onDead: (() -> Void)?
    
    init(model studentExistance: StudentExistance) {
        
        self.studentExistance = studentExistance
    }
    
    var id: String {
        
        return studentExistance.id
    }
    
    var studentID: String {
        
        return studentExistance.studentID
    }
    
    var studentName: String {
        
        return studentExistance.studentName
    }
    
    var time: Double {
        
        return studentExistance.time
    }
    
    var latitude: Double {
        
        return studentExistance.latitude
    }
    
    var longitude: Double {
        
        return studentExistance.longitude
    }
    
    var courseName: String {
        
        return studentExistance.courseName
    }
    
    var scanTeacherName: String {
        
        return studentExistance.scanTeacherName
    }
}
