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

//var onDead: (() -> Void)?

init(model studentExistance: StudentExistance) {
  self.studentExistance = studentExistance
}

var id: String {
  get {
    return studentExistance.id
  }
}
  
  var studentID: String {
    get {
      return studentExistance.studentID
    }
  }
    
  var studentName: String {
    get {
      return studentExistance.studentName
    }
  }
    
  var time: Double {
    get {
      return studentExistance.time
    }
  }
    
  var latitude: Double {
    get {
      return studentExistance.latitude
    }
  }
    
  var longitude: Double {
    get {
      return studentExistance.longitude
    }
  }
  var courseName: String {
    get {
      return studentExistance.courseName
    }
  }
  var scanTeacherName: String {
    get {
      return studentExistance.scanTeacherName
    }
  }
}


