//
//  StudentTimeInAndOutViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/3.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class StudentTimeInAndOutViewModel {
  
  let studentViewModel = Box([StudentViewModel]())
  
  let studentTimeInViemModel = Box([StudentExistanceViewModel]())
  
  let studentTimeOutViemModel = Box([StudentExistanceViewModel]())
  
  var cellDateDic = ["" : 0]
  
  var selectedDate = Date()
  
  var selectedStudent = 0
  
  var yearMonth = Calendar.current.dateComponents([.year, .month], from: Date())
  
  var existancesFetched: (() -> Void)?
  
  let group: DispatchGroup = DispatchGroup()
  

  
  func refreshCellDateDic() {
    
    cellDateDic.removeAll()

    var indexpathRow = 0
    
    for index in 0 ..< studentTimeInViemModel.value.count {

      let time = studentTimeInViemModel.value[index].time

      let key = Date(milliseconds: time).convertToString(dateformat: .day)

      cellDateDic[key] = indexpathRow

      indexpathRow += 1
    }
  }
  
  func fetchExistances(studentIndex: Int?, date: Date?) {

    if let date = date {
      
      selectedDate = date

      let selectedYearMonth = Calendar.current.dateComponents([.year, .month], from: date)

      if selectedYearMonth != yearMonth {
      
        yearMonth = selectedYearMonth
      
      } else {
      
        return
      }
    }
    
    if let studentIndex = studentIndex {
      selectedStudent = studentIndex
    }
    
    let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
    group.enter()
    queue1.async(group: group) {
      
        AttendanceManager.shared.fetchStudentExistances(studentIndex: self.selectedStudent,
                                               date: self.selectedDate,
                                               timeIn: true)
      { [weak self] result in
        switch result {
          
        case .success(let studentExistances):
          
          self?.setStudentExistances(studentExistances, timeIn: true)
          self?.group.leave()
          //            self?.onCallendarTap()
        case .failure(let error):
          print("fetchData.failure: \(error)")
          self?.group.leave()
        }
      }
    }
    
    let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
    
    group.enter()
    
    queue2.async(group: group) {
      
        AttendanceManager.shared.fetchStudentExistances(studentIndex: self.selectedStudent,
                                               date: self.selectedDate,
                                               timeIn: false)
      { [weak self] result in
        
        switch result {
          
        case .success(let studentExistances):
          
          self?.setStudentExistances(studentExistances, timeIn: false)
          self?.group.leave()
          //            self?.onCallendarTap()
          
        case .failure(let error):
          print("fetchData.failure: \(error)")
          self?.group.leave()
          
        }
      }
    }
    group.notify(queue: DispatchQueue.main) {
      print("Done")
      self.existancesFetched?()
    }
  }
//
//
//  func convertStudentToViewModels(from students: [Student]) -> [StudentViewModel] {
//    var viewModels = [StudentViewModel]()
//    for student in students {
//      let viewModel = StudentViewModel(model: student)
//      viewModels.append(viewModel)
//    }
//    return viewModels
//  }
  
//  func setSearchResult(_ students: [Student]) {
//
//    studentViewModel.value = convertStudentToViewModels(from: students)
//
//  }
  
  func convertStudentExistancesToViewModels(from records: [StudentExistance]) -> [StudentExistanceViewModel] {
    var viewModels = [StudentExistanceViewModel]()
    for record in records {
      let viewModel = StudentExistanceViewModel(model: record)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  
  func setStudentExistances(_ records: [StudentExistance], timeIn: Bool) {
    if timeIn == true {
      studentTimeInViemModel.value = convertStudentExistancesToViewModels(from: records)
    } else {
      studentTimeOutViemModel.value = convertStudentExistancesToViewModels(from: records)
    }
  }
  
  func convertStudentToViewModels(from records: [Student]) -> [StudentViewModel] {
    var viewModels = [StudentViewModel]()
    for record in records {
      let viewModel = StudentViewModel(model: record)
      viewModels.append(viewModel)
    }
    return viewModels
  }
  func setStudentViewModel() {
    guard let students = UserManager.shared.user.student else { return }
      studentViewModel.value = convertStudentToViewModels(from: students)
  }
}
