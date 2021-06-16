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
import FirebaseStorage

enum LoginError: Error {
    case idNotExistError(String)
}

class UserManager {
    
    static let shared = UserManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
    var user = User(id: "",
                    createdTime: -1,
                    userID: "",
                    name: "",
                    image: "",
                    cellPhoneNo: -1,
                    homePhoneNo: -1,
                    birthDay: -1,
                    email: "",
                    userType: nil,
                    workingHours: nil,
                    student: nil,
                    difficulty: nil,
                    note: nil) {
        didSet {
            updateStudents()
        }
        
    }
    
    //      var user = User(id: "ZTBCw5SJ1cgvO9DswRx11ZUE3At1",
    //                      createdTime: -1,
    //                      userID: "Ben",
    //                      name: "Ben Tee",
    //                      image:
    //        "https://firebasestorage.googleapis.com/v0/b/ecommunicationbook.appspot.com/o/e-communication-icon.jpg?alt=media&token=e23859b9-fc8f-4c1c-a9d8-a99af5495c5a",
    //                      cellPhoneNo: -1,
    //                      homePhoneNo: -1,
    //                      birthDay: -1,
    //                      email: "Ben@mail.com",
    //                      userType: nil,
    //                      workingHours: nil,
    //                      student: nil,
    //                      difficulty: nil,
    //                      note: nil) {
    //                        didSet {
    //                          updateStudents()
    //                        }
    //
    //      }
    
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
    
    func addUser(user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
        let document = fireStoreDataBase.collection("Users")
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
        
        fireStoreDataBase.collection("Users").document(uid).getDocument { (querySnapshot, error) in
            
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
        
        fireStoreDataBase.collection("Students")
            //      .order(by: "grade", descending: true)
            .whereField("parents", arrayContains: UserManager.shared.user.id)
            .getDocuments { (querySnapshot, error) in
                
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
