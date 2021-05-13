//
//  XXXManager.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//
/*
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
    
    lazy var db = Firestore.firestore()
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        db.collection("articles").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in
            
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var articles = [Article]()
                    
                    for document in querySnapshot!.documents {

                        do {
                            if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                                articles.append(article)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
//                            completion(.failure(FirebaseError.documentError))
                        }
                    }
                    
                    completion(.success(articles))
                }
        }
    }
    
    func publishArticle(article: inout Article, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("articles").document()
        article.id = document.documentID
        article.createdTime = Date().millisecondsSince1970
        document.setData(article.toDict) { error in
            
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
*/
