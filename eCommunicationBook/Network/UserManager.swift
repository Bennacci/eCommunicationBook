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
    
    var author: Author?
    
    func login(id: String = "", completion: @escaping (Result<Author, Error>) -> Void) {
    
        switch id {
        case "waynechen323":
            author = Author(
                id: id,
                email: "wayne@school.appworks.tw",
                name: "AKA小安老師"
            )
            completion(.success(author!))
        case "dlwlrma":
            author = Author(
                id: id,
                email: "dlwlrma@school.appworks.tw",
                name: "IU"
            )
            completion(.success(author!))
        // MARK: add your profile here
        default:
            completion(.failure(LoginError.idNotExistError("You have to add \(id) info in local data source")))
        }
    }
    
    func isLogin() -> Bool {
        return author != nil
    }
}
