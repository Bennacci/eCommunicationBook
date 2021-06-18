//
//  ChatroomManager.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/16.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class ChatroomManager {
    
    static let shared = ChatroomManager()
    
    lazy var conversationID: String = String.empty
    
    //    lazy var courseID: String = ""
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
    func sendMessage(message: inout Message, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase.collection("ChatRooms")
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
    
    func publishChatroom(chatRoom: inout ChatRoom, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = fireStoreDataBase.collection("ChatRooms").document()
        
        chatRoom.id = document.documentID
        
        chatRoom.createdTime = Date().millisecondsSince1970
        
        document.setData(chatRoom.toDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    
    func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
        
        let collection = fireStoreDataBase.collection("ChatRooms")
            //            .order(by: "createdTime")
            .whereField("members", arrayContains: UserManager.shared.user.id)
        
        collection.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var chatRooms = [ChatRoom]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let chatRoom = try document.data(as: ChatRoom.self, decoder: Firestore.Decoder()) {
                            
                            chatRooms.append(chatRoom)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(chatRooms))
            }
        }
    }
    
    func fetchMessages(chatRoomId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        
        let collection = fireStoreDataBase.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .order(by: "createdTime", descending: true)
        
        collection.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var messages = [Message]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let message = try document.data(as: Message.self, decoder: Firestore.Decoder()) {
                            
                            messages.append(message)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(messages))
            }
        }
    }
    
    func fetchConversation(completion: @escaping (Result<[Message], Error>) -> Void) {
        
        fireStoreDataBase.collection("ChatRooms")
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
                    
                    completion(.success(messages))
                }
            }
    }
    
}
