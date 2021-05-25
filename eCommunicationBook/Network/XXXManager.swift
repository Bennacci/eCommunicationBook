//
//  XXXManager.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum FirebaseError: Error {
  case documentError
}

enum MasterError: Error {
  case youKnowNothingError(String)
}

class XXXManager {
  
  static let shared = XXXManager()
  
  lazy var conversationID: String = ""
  
  lazy var db = Firestore.firestore()
  
  //    func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
  //
  //        db.collection("chatrooms").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in
  //
  //                if let error = error {
  //
  //                    completion(.failure(error))
  //                } else {
  //
  //                    var chatRooms = [ChatRoom]()
  //
  //                    for document in querySnapshot!.documents {
  //
  //                        do {
  //                            if let chatRoom = try document.data(as: ChatRoom.self, decoder: Firestore.Decoder()) {
  //                                chatRooms.append(chatRoom)
  //                            }
  //
  //                        } catch {
  //
  //                            completion(.failure(error))
  // //                            completion(.failure(FirebaseError.documentError))
  //                        }
  //                    }
  //
  //                    completion(.success(chatRooms))
  //                }
  //        }
  //    }
  
  func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
    
    db.collection("chatRooms")
      .order(by: "createdTime")
      .whereField("members", arrayContains: UserManager.shared.userID!)
      .addSnapshotListener { (documentSnapshot, error) in
        
        if let error = error {
          completion(.failure(error))
        } else {
          
          var chatRooms = [ChatRoom]()
          
          for document in documentSnapshot!.documents {
            
            do {
              if let chatRoom = try document.data(as: ChatRoom.self, decoder: Firestore.Decoder()) {
                chatRooms.append(chatRoom)
                //
                self.db.collection("chatRooms")
                  .document("\(chatRoom.id)")
                  .collection("messages")
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
                      
                      chatRooms[chatRooms.count-1].messages = messages
                      //                      print(messages)
                                            print(chatRooms)
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
    
    db.collection("chatRooms")
      .document(conversationID)
      .collection("messages")
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
    
    let document = db.collection("chatRooms")
      .document(conversationID)
      .collection("messages")
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
    
    let document = db.collection("users")
      .document()
    user.id = document.documentID
    user.createdTime = Double(Date().millisecondsSince1970)
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
    document.setData(course.toDict) { error in
      
      if let error = error {
        
        completion(.failure(error))
        
      } else {
        
        completion(.success("Success"))
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
  
    func fetchUser(completion: @escaping (Result<[User], Error>) -> Void) {
    
    db.collection("users").getDocuments { (querySnapshot, error) in
        
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
  
    func fetchStudentPerformances(completion: @escaping (Result<[StudentPerformance], Error>) -> Void) {
    
    db.collection("StudentPerformances").getDocuments { (querySnapshot, error) in
        
        if let error = error {
          
          completion(.failure(error))
        } else {
          
          var studentPerformances = [StudentPerformance]()
          
          for document in querySnapshot!.documents {
            
            do {
              if let studentPerformance = try document.data(as: StudentPerformance.self, decoder: Firestore.Decoder()) {
                studentPerformances.append(studentPerformance)
              }
            } catch {
              completion(.failure(error))
            }
          }
          completion(.success(studentPerformances))
        }
    }
  }
  
  func publishChatroom(chatRoom: inout ChatRoom, completion: @escaping (Result<String, Error>) -> Void) {
    
    let document = db.collection("chatRooms").document()
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
    
    let document = db.collection("chatRooms")
      .document()
      .collection("messages")
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
    
    db.collection("articles").document(article.id).delete() { error in
      
      if let error = error {
        
        completion(.failure(error))
      } else {
        
        completion(.success(article.id))
      }
    }
  }
}

