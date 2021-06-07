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
    get {
      return student.id
    }
  }
  
    var parents: [String] {
    get {
      return student.parents
    }
  }
  
    var name: String {
    get {
      return student.name
    }
  }
  
    var image: String? {
    get {
      return student.image
    }
  }
  
    var nationalID: String {
    get {
      return student.nationalID
    }
  }
  
    var grade: Int {
    get {
      return student.grade
    }
  }
  
    var birthDay: Double {
    get {
      return student.birthDay
    }
  }
  
    var emergencyContactPerson: String {
    get {
      return student.emergencyContactPerson
    }
  }
  
    var emergencyContactNo: Int {
    get {
      return student.emergencyContactNo
    }
  }
}
