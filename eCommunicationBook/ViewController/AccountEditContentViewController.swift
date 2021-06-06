//
//  AccountEditContentViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/6.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

protocol UpdateViewDelegate {
  func onUpdateView()
}

class AccountEditContentViewController: UIViewController {
  
  var viewModel = AccountEditContentViewModel()
  
  @IBOutlet weak var labelEditContentPageTitle: UILabel!
  
  @IBOutlet weak var textFieldContent: UITextField!
  
  @IBOutlet weak var labelContentLength: UILabel!
  
  var delegate: UpdateViewDelegate?
  
  @IBOutlet weak var heightConButtonSave: NSLayoutConstraint!
  
  override func viewDidLoad() {
    
    viewModel.onContentSaved = {
      self.leavePage()
    }
    
    viewModel.setUpContent()
    
    setUpView()
    
    
    
  }
  
  func leavePage() {
    delegate?.onUpdateView()
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func tapSaveButton(_ sender: Any) {
    viewModel.ontapSave()
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if let info = textField.text {
      viewModel.onContentChanged(with: info)
      
      labelContentLength.text = viewModel.contentLength
    }
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
        self.heightConButtonSave.constant =  25 + keyboardSize.height
        
      },completion: nil)
      
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
      self.heightConButtonSave.constant = 45
    },completion: nil)  }
  
  func setUpView() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    labelEditContentPageTitle.text = viewModel.editContentPageTitle
    
    
    textFieldContent.delegate = self
    
    textFieldContent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
    if viewModel.content == "" || viewModel.content == "-1" {
      textFieldContent.text = "Not set"
      textFieldContent.textColor = .darkGray
    } else {
      textFieldContent.text = viewModel.content
    }
    
    
    switch viewModel.editContentPageTitle {
    case "Local number", "Cell phone number":
      textFieldContent.keyboardType = .numberPad
    case "Email":
      textFieldContent.keyboardType = .emailAddress
    default:
      textFieldContent.keyboardType = .default
    }
    
  }
  
}

extension AccountEditContentViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.text == "Not set" {
      textField.text = ""
      textField.textColor = .black
    }
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textFieldText = textField.text,
      let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        return false
    }
    let substringToReplace = textFieldText[rangeOfTextToReplace]
    let count = textFieldText.count - substringToReplace.count + string.count
    return count <= 20
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if viewModel.content == "" || viewModel.content == "-1" {
      textFieldContent.text = "Not set"
      textFieldContent.textColor = .darkGray
    } else {
      textFieldContent.text = viewModel.content
    }
  }
}

