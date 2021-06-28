//
//  StudentManager.swift
//  eCommunicationBook
//
//  Created by Jade Chiang on 2021/6/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class StudentManager {
    
    static let shared = StudentManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()

    func addStudent(student: inout Student, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase
            .collection("Students")
            .document()
        
        student.id = document.documentID
        
        student.parents.append(UserManager.shared.user.id)
        
        document.setData(student.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
        
        let collection = fireStoreDataBase
            .collection("Students")
            .order(by: "grade", descending: true)
        
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
    
    func identifyStudent(id: String, completion: @escaping (Result<Student, Error>) -> Void) {
        
        let document = fireStoreDataBase
            .collection("Students")
            .document(id)
        
        document.getDocument { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else if querySnapshot?.data() == nil {
                
                completion(.failure(FirebaseError.noMatchData("User not found")))
                
            } else {
                
                do {
                    
                    if let student = try querySnapshot?.data(as: Student.self, decoder: Firestore.Decoder()) {
                        
                        completion(.success(student))
                    }
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchTeachers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        let collection = fireStoreDataBase
            .collection("User")
            .whereField("userType", isEqualTo: "teacher")
            .order(by: "name", descending: true)
        
        collection.addSnapshotListener { (documentSnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var teachers = [User]()
                
                for document in documentSnapshot!.documents {
                    
                    do {
                        
                        if let teacher = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            teachers.append(teacher)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(teachers))
            }
        }
    }
}
