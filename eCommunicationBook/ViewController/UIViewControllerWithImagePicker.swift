//
//  UIViewControllerWithImagePicker.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/31.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class UIViewControllerWithImagePicker: UIViewController {
  
//  static let shared = ImagePickerHelper()
  
  var imagePicker = UIImagePickerController()

  
  func showUploadMenu() {
    let controller = UIAlertController(title: "Upload an image", message: nil, preferredStyle: .actionSheet)
    
    let cameraAction = UIAlertAction(title: "Open Camera", style: .default) { _ in
      self.openCamera()
    }

    let libraryAction = UIAlertAction(title: "Pick from Album", style: .default) { _ in
      self.openAlbum()
    }
    let cancleAction = UIAlertAction(title: "Cancle", style: .cancel)
    
    controller.addAction(cameraAction)
    controller.addAction(libraryAction)
    controller.addAction(cancleAction)
    
    present(controller, animated: true)
  }
  
  private func openCamera() {
    imagePicker.sourceType = .camera
    present(imagePicker, animated: true)
  }
  
  private func openAlbum() {
    imagePicker.sourceType = .savedPhotosAlbum
    present(imagePicker, animated: true)
  }
}
