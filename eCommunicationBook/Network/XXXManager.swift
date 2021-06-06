//
//  XXXManager.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//
// swiftlint: disable file_length

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

enum FirebaseError: Error {
  case documentError
}

enum MasterError: Error {
  case youKnowNothingError(String)
  case noMatchData(String)
}

class XXXManager {
  
  static let shared = XXXManager()
  
  lazy var conversationID: String = ""
  
  lazy var courseID: String = ""
  
  //  lazy var lessonID: String = ""
  
  lazy var db = Firestore.firestore()
  
  func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
    
    
    
    db.collection("ChatRooms")
      //      .order(by: "createdTime")
      .whereField("members", arrayContains: UserManager.shared.user.id)
      .addSnapshotListener { (documentSnapshot, error) in
        
        if let error = error {
          completion(.failure(error))
        } else {
          
          var chatRooms = [ChatRoom]()
          
          for document in documentSnapshot!.documents {
            
            do {
              if var chatRoom = try document.data(as: ChatRoom.self, decoder: Firestore.Decoder()) {
                
                self.db.collection("ChatRooms")
                  .document("\(chatRoom.id)")
                  .collection("Messages")
                  .order(by: "createdTime", descending: true)
                  .getDocuments { (documentSnapshot, error) in
                    
                    if let error = error {
                      
                      completion(.failure(error))
                    } else {
                      
                      var messages = [Message]()
                      
                      for document in documentSnapshot!.documents {
                        
                        do {
                          if let message = try document.data(as: Message.self, decoder: Firestore.Decoder()) {
                            messages.append(message)
                            
                          }
                        } catch {
                          completion(.failure(error))
                        }
                      }
                      
                      chatRoom.messages = messages
                      
                      chatRooms.append(chatRoom)
                      
                      completion(.success(chatRooms))
                    }
                }
              }
            } catch {
              
              completion(.failure(error))
              // completion(.failure(FirebaseError.documentError))
            }
          }
        }
    }
  }
  
  func fetchConversation(completion: @escaping (Result<[Message], Error>) -> Void) {
    
    db.collection("ChatRooms")
      .document(conversationID)
      .collection("Messages")
      .order(by: "createdTime", descending: true)
      .addSnapshotListener { (documentSnapshot, error) in
        
        if let error = error {
          
          completion(.failure(error))
        } else {
          
          var messages = [Message]()
          
          for document in documentSnapshot!.documents {
            
            do {
              if let message = try document.data(as: Message.self, decoder: Firestore.Decoder()) {
                messages.append(message)
                
              }
            } catch {
              completion(.failure(error))
            }
          }
          print(messages)
          completion(.success(messages))
        }
    }
  }
  
  func sendMessage(message: inout Message, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("ChatRooms")
      .document(conversationID)
      .collection("Messages")
      .document()
    message.id = document.documentID
    message.createdTime = Double(Date().millisecondsSince1970)
    document.setData(message.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success("Success"))
      }
    }
  }
  
  func addUser(user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("Users")
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
  
  func addCourse(course: inout Course, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("Courses")
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
      
      let document = self.db
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
  
  func addEvent(event: inout Event, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("Events")
      .document()
    event.id = document.documentID
    //    course.createdTime = Double(Date().millisecondsSince1970)
    document.setData(event.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success("Success"))
      }
    }
  }
  
  func addSign(sign: inout Event, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("Sign")
      .document()
    sign.id = document.documentID
    //    course.createdTime = Double(Date().millisecondsSince1970)
    document.setData(sign.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success("Success"))
      }
    }
  }
  
  func addStudent(student: inout Student, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("Students")
      .document()
    student.id = document.documentID
    student.parents.append(UserManager.shared.user.id)
    //    course.createdTime = Double(Date().millisecondsSince1970)
    document.setData(student.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success("Success"))
      }
    }
  }
  
  func saveLesson(lesson: inout Lesson, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("Courses")
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
    
    let document = db.collection("StudentLessonRecords")
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
  
  func fetchAttendance(courseName: String, completion: @escaping (Result<[[StudentExistance]], Error>) -> Void) {
    
    let semaphore = DispatchSemaphore(value: 0)
    let dispatchQ = DispatchQueue(label: "myQueue", qos: .userInitiated)

    let courseInfo = courseName.components(separatedBy: ":")
//        let name = courseInfo[0]
    let lessonCount = courseInfo[1]
    var studentAttendancess = [[StudentExistance]]()
    
    
    for index in 0 ... Int(lessonCount)! {
            
      dispatchQ.async {

        self.db.collection("StudentAttendances")
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
  
  
  
  func writeAttendance(studentExistance: inout StudentExistance,
                       completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db
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
    let document = db
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
    let document = db
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
  
  func uploadPickerImage(pickerImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    
    let uuid = UUID().uuidString
    
    guard let image = pickerImage.jpegData(compressionQuality: 0.5) else { return }
    
    let storageRef = Storage.storage().reference()
    
    let imageRef = storageRef.child("StudentLessonRecordImages").child("\(uuid).jpg")
    
    imageRef.putData(image, metadata: nil) { metadata, error in
      
      if let error = error {
        
        completion(.failure(error))
      }
      guard let _ = metadata else {return}
      
      imageRef.downloadURL { url, error in
        
        if let url = url {
          
          completion(.success(url.absoluteString))
          
        } else if let error = error {
          
          completion(.failure(error))
        }
      }
    }
  }
  
  
  func fetchCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
    
    db.collection("Courses")
      //      .order(by: "name ")
      .whereField("teachers", arrayContains: UserManager.shared.user.id)
      .getDocuments { (querySnapshot, error) in
        
        if let error = error {
          completion(.failure(error))
        } else {
          
          var courses = [Course]()
          
          for document in querySnapshot!.documents {
            
            do {
              if var course = try document.data(as: Course.self, decoder: Firestore.Decoder()) {
                
                self.db.collection("Courses")
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
              // completion(.failure(FirebaseError.documentError))
            }
          }
        }
    }
  }
  
  func identifyUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
    
    db.collection("Users").document(uid).getDocument { (querySnapshot, error) in
      
      if let error = error {
        
        completion(.failure(error))
        print(error)
      } else if querySnapshot?.data() == nil {
        completion(.failure(MasterError.noMatchData("User not found")))
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
    
    db.collection("Users").getDocuments { (querySnapshot, error) in
      
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
    
    db.collection("User")
      .whereField("userType", isEqualTo: "teacher")
      .order(by: "name", descending: true)
      .addSnapshotListener { (documentSnapshot, error) in
        
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
          print(teachers)
          completion(.success(teachers))
        }
    }
  }
  
  func fetchUserStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
    
    db.collection("Students")
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
  
  func fetchStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
    
    db.collection("Students")
      .order(by: "grade", descending: true)
      .addSnapshotListener { (documentSnapshot, error) in
        
        if let error = error {
          
          completion(.failure(error))
        } else {
          
          var students = [Student]()
          
          for document in documentSnapshot!.documents {
            
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
  
  func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
    
    db.collection("Events").getDocuments { (querySnapshot, error) in
      
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
  
  func fetchStudentExistances(studentIndex: Int,
                              date: Date,
                              timeIn: Bool,
                              completion: @escaping (Result<[StudentExistance], Error>) -> Void) {
    
    let year = date.convertToString(dateformat: .year)
    let month = date.convertToString(dateformat: .month)
    
    var collectionName = ""
    
    if timeIn == true {
      
      collectionName = "StudentTimeIns"
      
    } else {
      
      collectionName = "StudentTimeOuts"
    }
    
    guard let student = UserManager.shared.students?[studentIndex] else {
      return completion(.failure(MasterError.noMatchData("No Student")))
    }
    
    db.collection(collectionName)
      .document(year)
      .collection(month)
      .whereField("studentID", isEqualTo: student.id)
      .order(by: "time", descending: true)
      .getDocuments { (querySnapshot, error) in
        
        if let error = error {
          
          completion(.failure(error))
          
        } else {
          
          var studentExistances = [StudentExistance]()
          
          for document in querySnapshot!.documents {
            
            do {
              
              if let studentExistance = try document.data(as: StudentExistance.self, decoder: Firestore.Decoder()) {
                
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
  
  
  func fetchStudentLessonRecord(completion: @escaping (Result<[StudentLessonRecord], Error>) -> Void) {
    
    db.collection("StudentLessonRecords")
      .getDocuments { (querySnapshot, error) in
        
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
  func fetchStudentLessonRecord(courseName: String, courseLesson: Int, completion: @escaping (Result<[StudentLessonRecord], Error>) -> Void) {
    
    db.collection("StudentLessonRecords")
    .whereField("courseName", isEqualTo: courseName)
    .whereField("courseLesson", isEqualTo: courseLesson)
    .getDocuments { (querySnapshot, error) in
        
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
  
  func publishChatroom(chatRoom: inout ChatRoom, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("ChatRooms").document()
    chatRoom.id = document.documentID
    //      chatRoom.createdTime = Date().millisecondsSince1970
    document.setData(chatRoom.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success("Success"))
      }
    }
  }
  
  func publishArticle(message: inout Message, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("ChatRooms")
      .document()
      .collection("Messages")
      .document()
    message.id = document.documentID
    message.createdTime = Double(Date().millisecondsSince1970)
    document.setData(message.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success("Success"))
      }
    }
  }
  
  func deleteArticle(article: Article, completion: @escaping (Result<String, Error>) -> Void) {
    
    if !UserManager.shared.isLogin() {
      print("who r u?")
      return
    }
    
    if let author = article.author {
      if author.id == "waynechen323"
        && article.category.lowercased() != "test"
        && !article.category.trimmingCharacters(in: .whitespaces).isEmpty {
        completion(.failure(MasterError.youKnowNothingError("You know nothing!! \(author.name)")))
        return
      }
    }
    
    db.collection("articles").document(article.id).delete { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success(article.id))
      }
    }
  }
}

// swiftlint: enable file_length
