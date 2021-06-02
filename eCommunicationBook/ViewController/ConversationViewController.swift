//
//  ConversationViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
  
//  weak var delegate: PublishDelegate?
  
  let viewModel = ConversationViewModel()
  
  @IBOutlet weak var conversationTableView: UITableView!
  
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var messageContentTextView: UITextView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.backgroundColor = UIColor(white: 0.0, alpha: 0)
    
    conversationTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
    
    self.tabBarController?.tabBar.isHidden = true
    //      self.navigationController?.setNavigationBarHidden(true, animated: true)
    //      self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 0)
    // Do any additional setup after loading the view.
    setUpTextView()
    
    viewModel.fetchData()
    
    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.conversationTableView.reloadData()
      }
    }
    viewModel.messageViewModel.bind { [weak self] messages in
      //            self?.tableView.reloadData()
      self?.viewModel.onRefresh()
    }
  }
  
  @IBAction func onTapSend(_ sender: Any) {
    viewModel.onTapSend()
    messageContentTextView.text = nil
  }
}



extension ConversationViewController: UITableViewDelegate {
  
}

extension ConversationViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.viewModel.messageViewModel.value.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if viewModel.messageViewModel.value[indexPath.row].senderID == UserManager.shared.user.id {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: UserMessageTableViewCell.identifier, for: indexPath)
      
      guard let userMessageCell = cell as? UserMessageTableViewCell else {
        
        return cell
      }
      
      let cellViewModel = self.viewModel.messageViewModel.value[indexPath.row]
      
      userMessageCell.setup(viewModel: cellViewModel)
      userMessageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
      return userMessageCell
    } else {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: PartnerMessageTableViewCell.identifier, for: indexPath)
      
      guard let partnerMessageCell = cell as? PartnerMessageTableViewCell else {
        
        return cell
      }
      
      let cellViewModel = self.viewModel.messageViewModel.value[indexPath.row]
      
      partnerMessageCell.setup(viewModel: cellViewModel)
      partnerMessageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
      return partnerMessageCell
    }
  }
}

extension ConversationViewController: UITextViewDelegate {
  
  func setUpTextView() {
    messageContentTextView.delegate = self
    messageContentTextView.text = "type message..."
    messageContentTextView.textColor = .lightGray
  }
  
  func textViewDidChange(_ textView: UITextView) {
    
    let maxHeight: CGFloat = 90.0
    let minHeight: CGFloat = 30.0
    textViewHeightConstraint.constant = min(maxHeight, max(minHeight, textView.contentSize.height))
    self.view.layoutIfNeeded()
    
    guard let content = textView.text else {
      return
    }
    viewModel.onContentChanged(text: content)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "type message..."
      textView.textColor = .lightGray
    }
  }
  
}
