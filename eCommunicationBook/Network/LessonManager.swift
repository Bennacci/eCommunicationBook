//
//  LessonManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/16.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class LessonManager {
    
    static let shared = LessonManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
    lazy var courseID: String = String.empty
    
    func addCourse(course: inout Course, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase.collection("Courses")
            .document()
        course.id = document.documentID
        //    course.createdTime = Double(Date().millisecondsSince1970)
        //    print(course.toDict)
        //    print(course)
        //    course.lessons = nil
        
        document.setData(course.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                //        self.courseID = document.documentID
                completion(.success("Success"))
            }
        }
    }
    
    func addLesson(course: inout Course, completion: @escaping (Result<String, Error>) -> Void) {
        var lessons = course.lessons
        
        for index in 0 ..< lessons!.count {
            
            let document = self.fireStoreDataBase
                .collection("Courses")
                .document(course.id)
                .collection("Lessons")
                .document()
            
            lessons![index].id = document.documentID
            
            document.setData(lessons![index].toDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
    }
    
    func saveLesson(lesson: inout Lesson, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase.collection("Courses")
            .document(courseID)
            .collection("Lessons")
            .document(lesson.id)
        lesson.id = document.documentID
        document.setData(lesson.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func saveStudentLessonRecord(studentLessonRecord: inout StudentLessonRecord,
                                 completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase.collection("StudentLessonRecords")
            .document()
        
        studentLessonRecord.id = document.documentID
        
        document.setData(studentLessonRecord.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        
        var collection = fireStoreDataBase.collection("Courses")
            .whereField("teachers", arrayContains: UserManager.shared.user.id)
        
        if UserManager.shared.user.userType == "parents" {
            
            guard let student = UserManager.shared.user.student else {return}
            
            let studentInfo = student[0].name + ":" + student[0].id
            
            collection = fireStoreDataBase.collection("Courses")
                .whereField("students", arrayContains: studentInfo)
        }
        
        collection.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var courses = [Course]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if var course = try document.data(as: Course.self, decoder: Firestore.Decoder()) {
                            
                            self.fireStoreDataBase.collection("Courses")
                                .document("\(course.id)")
                                .collection("Lessons")
                                .order(by: "number", descending: false)
                                .getDocuments { (querySnapshot, error) in
                                    
                                    if let error = error {
                                        
                                        completion(.failure(error))
                                        
                                    } else {
                                        
                                        var lessons = [Lesson]()
                                        
                                        for document in querySnapshot!.documents {
                                            
                                            do {
                                                
                                                if let lesson = try document.data(as: Lesson.self, decoder: Firestore.Decoder()) {
                                                    
                                                    lessons.append(lesson)
                                                }
                                                
                                            } catch {
                                                
                                                completion(.failure(error))
                                            }
                                        }
                                        
                                        course.lessons = lessons
                                        
                                        courses.append(course)
                                        
                                        completion(.success(courses))
                                    }
                                }
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
    func fetchStudentLessonRecord(completion: @escaping (Result<[StudentLessonRecord], Error>) -> Void) {
        
        guard let student = UserManager.shared.user.student else { return }
        
        fireStoreDataBase.collection("StudentLessonRecords")
            .whereField("studentID", isEqualTo: student[0].id)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    var studentLessonRecords = [StudentLessonRecord]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let studentLessonRecord = try document.data(as: StudentLessonRecord.self, decoder:
                                                                            Firestore.Decoder()) {
                                
                                studentLessonRecords.append(studentLessonRecord)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(studentLessonRecords))
                }
            }
    }
    
    func fetchStudentLessonRecord(courseName: String, courseLesson: Int, completion: @escaping (Result<[StudentLessonRecord], Error>) -> Void) {
        
        var collection = fireStoreDataBase.collection("StudentLessonRecords")
            .whereField("courseName", isEqualTo: courseName)
            .whereField("courseLesson", isEqualTo: courseLesson)
        
        if UserManager.shared.user.userType == "parents" {
            
            guard let student = UserManager.shared.user.student else {return}
            
            collection = fireStoreDataBase.collection("StudentLessonRecords")
                .whereField("courseName", isEqualTo: courseName)
                .whereField("courseLesson", isEqualTo: courseLesson)
                .whereField("studentID", isEqualTo: student[0].id)
        }
        
        collection.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var studentLessonRecords = [StudentLessonRecord]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let studentLessonRecord = try document.data(as: StudentLessonRecord.self, decoder: Firestore.Decoder()) {
                            
                            studentLessonRecords.append(studentLessonRecord)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(studentLessonRecords))
            }
        }
    }
}
