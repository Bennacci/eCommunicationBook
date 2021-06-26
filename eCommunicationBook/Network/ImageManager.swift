//
//  ImageManager.swift
//  eCommunicationBook
//
//  Created by Jade Chiang on 2021/6/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class ImageManager {
    
    static let shared = ImageManager()
    
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
}
