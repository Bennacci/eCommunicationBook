//
//  XXXManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

enum FirebaseError: Error {
    //    case youKnowNothingError(String)
    case noMatchData(String)
}

class XXXManager {
    
    static let shared = XXXManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
    func uploadPickerImage(pickerImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        
        let uuid = UUID().uuidString
        
        guard let image = pickerImage.jpegData(compressionQuality: 0.5) else { return }
        
        let storageRef = Storage.storage().reference()
        
        let imageRef = storageRef.child("StudentLessonRecordImages").child("\(uuid).jpg")
        
        imageRef.putData(image, metadata: nil) { metadata, error in
            
            if let error = error {
                
                completion(.failure(error))
            }
            
            if metadata == nil {

                return
            }
            
            imageRef.downloadURL { url, error in
                
                if let url = url {
                    
                    completion(.success(url.absoluteString))
                    
                } else if let error = error {
                    
                    completion(.failure(error))
                }
            }
        }
    }
    
    func addEvent(event: inout Event, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase
            .collection("Events")
            .document()
        
        event.id = document.documentID
        
        document.setData(event.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        
        let collection = fireStoreDataBase
            .collection("Events")
        
        collection.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var events = [Event]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let event = try document.data(as: Event.self, decoder: Firestore.Decoder()) {
                            
                            events.append(event)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(events))
            }
        }
    }
    
    func addSign(sign: inout Event, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase
            .collection("Signs")
            .document()
        
        sign.id = document.documentID
        
        document.setData(sign.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchSign(completion: @escaping (Result<[Event], Error>) -> Void) {
        
        fireStoreDataBase.collection("Signs").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var signs = [Event]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let sign = try document.data(as: Event.self, decoder: Firestore.Decoder()) {
                            
                            signs.append(sign)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(signs))
            }
        }
    }
    
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
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        fireStoreDataBase.collection("Users").getDocuments { (querySnapshot, error) in
            
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
}
