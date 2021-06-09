//
//  UserManager.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//

import Foundation

enum LoginError: Error {
  case idNotExistError(String)
}

class UserManager {
  
  static let shared = UserManager()
  
  var user = User(id: "ZTBCw5SJ1cgvO9DswRx11ZUE3At1",
                  createdTime: -1,
                  userID: "Ben",
                  name: "Ben Tee",
                  image:
    "https://firebasestorage.googleapis.com/v0/b/ecommunicationbook.appspot.com/o/e-communication-icon.jpg?alt=media&token=e23859b9-fc8f-4c1c-a9d8-a99af5495c5a",
                  cellPhoneNo: 09161235456,
                  homePhoneNo: 28123456,
                  birthDay: -1,
                  email: "Ben@mail.com",
                  userType: nil,
                  workingHours: nil,
                  student: [Student(id: "osEhOENEZqwQIKKwF0k1",
                                    parents: [""],
                                    name: "Student A",
                                    image: nil,
                                    nationalID: "",
                                    grade: 1,
                                    birthDay: -1,
                                    emergencyContactPerson: "",
                                    emergencyContactNo: -1)],
                  difficulty: nil,
                  note: nil) {
                    didSet {
                      updateStudents()
                    }
    
  }
  
  lazy var students: [Student]? = nil
  
  lazy var selectedUsers: [UserViewModel]? = nil
  
  lazy var selectedStudents: [StudentViewModel]? = nil
  
  lazy var selectedDays: [RoutineHour]? = nil
  
  func login(id: String = "", completion: @escaping (Result<String, Error>) -> Void) {
    
    switch id {
    case "waynechen323":
//      userID = "John"
      completion(.success(user.id))
    // MARK: add your profile here
    default:
      completion(.failure(LoginError.idNotExistError("You have to add \(id) info in local data source")))
    }
  }
  
  func isLogin() -> Bool {
    return user.id != ""
  }
  
  //    var author: Author?
  
  //    func login(id: String = "", completion: @escaping (Result<Author, Error>) -> Void) {
  //
  //        switch id {
  //        case "waynechen323":
  //            author = Author(
  //                id: id,
  //                email: "wayne@school.appworks.tw",
  //                name: "AKA小安老師"
  //            )
  //            completion(.success(author!))
  //        case "dlwlrma":
  //            author = Author(
  //                id: id,
  //                email: "dlwlrma@school.appworks.tw",
  //                name: "IU"
  //            )
  //            completion(.success(author!))
  //        // MARK: add your profile here
  //        default:
  //            completion(.failure(LoginError.idNotExistError("You have to add \(id) info in local data source")))
  //        }
  //    }
  
  //    func isLogin() -> Bool {
  //        return author != nil
  //    }
  
  func updateStudents() {
    XXXManager.shared.fetchUserStudents { [weak self] result in
      
      switch result {
        
      case .success(let students):
        
        self?.setSearchStudentResult(with: students)
        
      case .failure(let error):
        
        print("fetchData.failure: \(error)")
      }
    }
  }
  
  func setSearchStudentResult(with students: [Student]) {
    
    self.students = students
  }
}
