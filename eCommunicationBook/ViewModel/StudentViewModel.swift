//
//  StudentViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/25.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class StudentViewModel: SearchUserPageMaterial {
    var student: Student
    
    init(model student: Student) {
        self.student = student
    }
    
    var id: String {
        return student.id
    }
    
    var parents: [String] {
        return student.parents
    }
    
    var name: String {
        return student.name
    }
    
    var image: String? {
        return student.image
    }
    
    var nationalID: String {
        return student.nationalID
    }
    
    var grade: Int {
        return student.grade
    }
    
    var birthDay: Double {
        return student.birthDay
    }
    
    var emergencyContactPerson: String {
        return student.emergencyContactPerson
    }
    
    var emergencyContactNo: Int {
        return student.emergencyContactNo
    }
}
