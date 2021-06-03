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
  
  var selectedDate = Date()
  
  var selectedStudent = 0
  
  var yearMonth = Calendar.current.dateComponents([.year, .month], from: Date())
  
//  func onCalendarTapped(day: Date) {
//
//    let tappedYearMonth = Calendar.current.dateComponents([.year, .month], from: day)
//
//    if tappedYearMonth != yearMonth {
//      yearMonth = tappedYearMonth
//      fetchExistances(studentIndex: nil, date: day)
//    }
//  }
  
  var existancesFetched: (()->Void)?
  
  let group: DispatchGroup = DispatchGroup()
  
  
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
      
      XXXManager.shared.fetchStudentExistances(studentIndex: self.selectedStudent, date: self.selectedDate, timeIn: true) { [weak self] result in
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
      
      XXXManager.shared.fetchStudentExistances(studentIndex: self.selectedStudent, date: self.selectedDate, timeIn: false) { [weak self] result in
        
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
}
