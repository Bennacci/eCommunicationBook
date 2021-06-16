//
//  AttendanceManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/16.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class AttendanceManager {
    
    static let shared = AttendanceManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
    func writeAttendance(studentExistance: inout StudentExistance,
                         completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase
            .collection("StudentAttendances")
            .document(studentExistance.courseName)
            .collection("\(studentExistance.courseLesson)")
            .document()
        
        studentExistance.id = document.documentID
        
        studentExistance.time = Double(Date().millisecondsSince1970)
        
        studentExistance.scanTeacherName = UserManager.shared.user.id
        
        document.setData(studentExistance.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func writeTimeIn(studentExistance: inout StudentExistance,
                     completion: @escaping (Result<String, Error>) -> Void) {
        
        let year = Date().convertToString(dateformat: .year)
        
        let month = Date().convertToString(dateformat: .month)
        
        let document = fireStoreDataBase
            .collection("StudentTimeIns")
            .document(year)
            .collection(month)
            .document()
        
        studentExistance.id = document.documentID
        
        studentExistance.time = Double(Date().millisecondsSince1970)
        
        studentExistance.scanTeacherName = UserManager.shared.user.id
        
        document.setData(studentExistance.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func writeTimeOut(studentExistance: inout StudentExistance,
                      completion: @escaping (Result<String, Error>) -> Void) {
        
        let year = Date().convertToString(dateformat: .year)
        
        let month = Date().convertToString(dateformat: .month)
        
        let document = fireStoreDataBase
            .collection("StudentTimeOuts")
            .document(year)
            .collection(month)
            .document()
        
        studentExistance.id = document.documentID
        
        studentExistance.time = Double(Date().millisecondsSince1970)
        
        studentExistance.scanTeacherName = UserManager.shared.user.id
        
        document.setData(studentExistance.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchAttendance(courseName: String, completion: @escaping (Result<[[StudentExistance]], Error>) -> Void) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQ = DispatchQueue(label: "myQueue", qos: .userInitiated)
        
        let courseInfo = courseName.components(separatedBy: ":")
        //        let name = courseInfo[0]
        
        let lessonCount = courseInfo[1]
        
        var studentAttendancess = [[StudentExistance]]()
        
        for index in 0 ... Int(lessonCount)! {
            
            dispatchQ.async {
                
                self.fireStoreDataBase.collection("StudentAttendances")
                    .document(courseName)
                    .collection("\(index)")
                    .getDocuments { (querySnapshot, error) in
                        
                        if let error = error {
                            
                            completion(.failure(error))
                            
                            semaphore.signal()
                            
                        } else {
                            
                            var studentAttendances = [StudentExistance]()
                            
                            for document in querySnapshot!.documents {
                                
                                do {
                                    
                                    if let studentAttendance = try document.data(as: StudentExistance.self, decoder: Firestore.Decoder()) {
                                        
                                        studentAttendances.append(studentAttendance)
                                    }
                                    
                                } catch {
                                    
                                    completion(.failure(error))
                                    
                                    semaphore.signal()
                                }
                            }
                            
                            studentAttendancess.append(studentAttendances)
                            
                            semaphore.signal()
                        }
                    }
                
                semaphore.wait()
            }
        }
        
        dispatchQ.async {
            
            completion(.success(studentAttendancess))
        }
    }
    
    func fetchStudentExistances(studentIndex: Int,
                                date: Date,
                                timeIn: Bool,
                                completion: @escaping (Result<[StudentExistance], Error>) -> Void) {
        
        let year = date.convertToString(dateformat: .year)
        
        let month = date.convertToString(dateformat: .month)
        
        var collectionName = String.empty
        
        if timeIn == true {
            
            collectionName = "StudentTimeIns"
            
        } else {
            
            collectionName = "StudentTimeOuts"
        }
        
        guard let student = UserManager.shared.user.student, student.count > 0 else {
            
            return completion(.failure(FirebaseError.noMatchData("No Student")))
        }
        
        fireStoreDataBase.collection(collectionName)
            .document(year)
            .collection(month)
            .whereField("studentID", isEqualTo: student[studentIndex].id)
            .order(by: "time", descending: false)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    var studentExistances = [StudentExistance]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let studentExistance = try document.data(as: StudentExistance.self,
                                                                        decoder: Firestore.Decoder()) {
                                
                                studentExistances.append(studentExistance)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(studentExistances))
                }
            }
    }
}
