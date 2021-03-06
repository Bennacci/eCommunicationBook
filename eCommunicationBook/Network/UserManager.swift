//
//  UserManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum FirebaseError: Error {
    
    case noMatchData(String)
}

class UserManager {
    
    static let shared = UserManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
    var user = User(id: String.empty,
                    createdTime: -1,
                    userID: String.empty,
                    name: String.empty,
                    image: String.empty,
                    cellPhoneNo: -1,
                    homePhoneNo: -1,
                    birthDay: -1,
                    email: String.empty,
                    userType: nil,
                    workingHours: nil,
                    student: nil,
                    difficulty: nil,
                    note: nil) {

        didSet {

            updateStudents()
        }
    }
    
//          var user = User(id: "ZTBCw5SJ1cgvO9DswRx11ZUE3At1",
//                          createdTime: -1,
//                          userID: "Ben",
//                          name: "Ben Tee",
//                          image: "",
//                          cellPhoneNo: -1,
//                          homePhoneNo: -1,
//                          birthDay: -1,
//                          email: "Ben@mail.com",
//                          userType: nil,
//                          workingHours: nil,
//                          student: nil,
//                          difficulty: nil,
//                          note: nil) {
//                            didSet {
//                              updateStudents()
//                            }
//          }
    
    lazy var selectedUsers: [UserViewModel]? = nil
    
    lazy var selectedStudents: [StudentViewModel]? = nil
    
    lazy var selectedDays: [RoutineHour]? = nil
    
    func addUser(user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase
            .collection("Users")
            .document(user.id)
        
        if user.createdTime == -1 {
            
            user.createdTime = Double(Date().millisecondsSince1970)
        }
        
        document.setData(user.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func identifyUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        fireStoreDataBase
            .collection("Users")
            .document(uid)
            .getDocument { (querySnapshot, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                    print(error)
                    
                } else if querySnapshot?.data() == nil {
                    
                    completion(.failure(FirebaseError.noMatchData("User not found")))
                    
                } else {
                    
                    do {
                        
                        if let user = try querySnapshot?.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            completion(.success(user))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        fireStoreDataBase
            .collection("Users")
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    var users = [User]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                
                                users.append(user)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(users))
                }
            }
    }
    
    func updateStudents() {
        
        fetchUserStudents { [weak self] result in
            
            switch result {
            
            case .success(let students):
                
                self?.setSearchStudentResult(with: students)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func fetchUserStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
        
        let collection = fireStoreDataBase
            .collection("Students")
            //      .order(by: "grade", descending: true)
            .whereField("parents", arrayContains: UserManager.shared.user.id)
        
        collection.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var students = [Student]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let student = try document.data(as: Student.self, decoder: Firestore.Decoder()) {
                            students.append(student)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(students))
            }
        }
    }
    
    func setSearchStudentResult(with students: [Student]) {
        
        if students.isEmpty != true {
            
            self.user.student = students
        }
    }
}
