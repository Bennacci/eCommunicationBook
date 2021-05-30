//
//  ScanStudentQRCodeViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/30.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ScanStudentQRCodeViewModel {
  
  var timeIn: Bool = true {
    didSet {
      studentExistance.studentName = ""
    }
  }
  
  var studentExistance = StudentExistance(
    id: "",
    studentID: "",
    studentName: "",
    time: -1,
    latitude: -1,
    longitude: -1,
    scanTeacherName: "")
  
  func onScanedAQRCode(info: String) {
    
    let lines = info.components(separatedBy: "\n")
    
//    let qrCodeInfo = info.split(whereSeparator: \.isNewline)
    if lines.count >= 2 {
      if  studentExistance.studentName != lines[0] {
        studentExistance.studentName = lines[0]
        studentExistance.studentID = lines[1]
        if timeIn == true {
          writeTimeIn(with: &studentExistance)
        } else {
          writeTimeOut(with: &studentExistance)
        }
      }
    }
  }
  
  func onCurrentLocationChanged(latitude: Double, longitude: Double) {
    studentExistance.latitude = latitude
    studentExistance.longitude = longitude
  }
  
  var wroteInSuccess: (() -> Void)?
  
  //  var wroteInFailure: (() -> Void)?
  
  var wroteOutSuccess: (() -> Void)?
  
  //  var wroteOutFailure: (() -> Void)?
  
  func writeTimeIn(with studentExistance: inout StudentExistance) {
  
    LKProgressHUD.show()

    XXXManager.shared.writeTimeIn(studentExistance: &studentExistance) { result in
     
      LKProgressHUD.dismiss()

      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        
        self.wroteInSuccess?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
        
        //        self.wroteInFailure?()
      }
    }
  }
  func writeTimeOut(with studentExistance: inout StudentExistance) {
    
    LKProgressHUD.show()

    XXXManager.shared.writeTimeOut(studentExistance: &studentExistance) { result in
      
      LKProgressHUD.dismiss()

      switch result {
        
      case .success:
        
        print("onTapPublish, success")
        
        self.wroteOutSuccess?()
        
      case .failure(let error):
        
        print("publishArticle.failure: \(error)")
        
        //        self.wroteOutFailure?()
        
      }
    }
  }
}
