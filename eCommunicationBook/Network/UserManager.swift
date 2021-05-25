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
  
  var userID: String? = "no.00000"
  
  var userType: UserType = .teacher
  
  lazy var selectedUsers: [UserViewModel]? = nil
  
  lazy var selectedStudents: [StudentViewModel]? = nil
  
  lazy var selectedDays: [RoutineHour]? = nil
  
  func login(id: String = "", completion: @escaping (Result<String, Error>) -> Void) {
    
    switch id {
    case "waynechen323":
      userID = "no.00000"
      completion(.success(userID!))
    // MARK: add your profile here
    default:
      completion(.failure(LoginError.idNotExistError("You have to add \(id) info in local data source")))
    }
  }
  
  func isLogin() -> Bool {
    return userID != nil
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
