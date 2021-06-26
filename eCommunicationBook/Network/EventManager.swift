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

class EventManager {
    
    static let shared = EventManager()
    
    lazy var fireStoreDataBase = Firestore.firestore()
    
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
        
        let collection = fireStoreDataBase
            .collection("Signs")
            
        collection.getDocuments { (querySnapshot, error) in
            
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
}
