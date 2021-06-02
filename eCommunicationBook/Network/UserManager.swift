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
  
  var user = User(id: "",
                  createdTime: -1,
                  userID: "",
                  name: "",
                  image: nil,
                  cellPhoneNo: -1,
                  homePhoneNo: -1,
                  birthDay: -1,
                  email: "",
                  userType: nil,
                  workingHours: nil,
                  difficulty: nil,
                  note: nil)
  
//  var userID: String? = "John"
  
//  var userType: UserType = .teacher
  
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
}
