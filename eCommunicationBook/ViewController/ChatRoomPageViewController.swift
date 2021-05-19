//
//  ChatRoomPageViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import EasyRefresher

class ChatRoomPageViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  
  let viewModel = ChatRoomPageViewModel()
  
  //  let conversationViewModel = ConversationViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.backgroundColor = .blue
    
    self.navigationItem.title = "Chats"
    
    // Do any additional setup after loading the view.
    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    viewModel.chatRoomViewModel.bind { [weak self] chatrooms in
      //            self?.tableView.reloadData()
      self?.viewModel.onRefresh()
    }
    
    viewModel.scrollToTop = { [weak self] () in
      
      self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    viewModel.fetchData()
    
    setupRefresher()
  }
  
  func setupRefresher() {
    self.tableView.refresh.header = RefreshHeader(delegate: self)
    
    tableView.refresh.header.addRefreshClosure { [weak self] in
      self?.viewModel.fetchData()
      self?.tableView.refresh.header.endRefreshing()
    }
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   if segue.identifier == "navigateToPublish",
   let publishViewController = segue.destination as? PublishViewController {
   
   publishViewController.delegate = self
   
   }
   }
   */
  @IBAction func searchUser(_ sender: Any) {
    if let nextVC = UIStoryboard.searchUser.instantiateInitialViewController() {
//             nextVC.modalPresentationStyle = .fullScreen
//       //      show(nextVC, sender: nil)
//             present(nextVC, animated: false, completion: nil)
             self.navigationController?.show(nextVC, sender: nil)
    } else { return }
  }
}

extension ChatRoomPageViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return viewModel.chatRoomViewModel.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.identifier, for: indexPath)
    
    guard let chatRoomTableViewCell = cell as? ChatRoomTableViewCell else {
      return cell
    }
    
    let cellViewModel = self.viewModel.chatRoomViewModel.value[indexPath.row]
//    cellViewModel.onDead = { [weak self] () in
//      print("onDead")
//      self?.viewModel.fetchData()
//    }
    chatRoomTableViewCell.setup(viewModel: cellViewModel)
    
    return chatRoomTableViewCell
  }
}

extension ChatRoomPageViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ConversationPage", sender: nil)
    viewModel.onTap(withIndex: indexPath.row)
  }
}

extension ChatRoomPageViewController: RefreshDelegate {
  func refresherDidRefresh(_ refresher: Refresher) {
    print("refresherDidRefresh")
  }
}

// extension ChatRoomPageViewController: PublishDelegate {
//  func onPublished() {
//    viewModel.fetchData()
//    viewModel.onScrollToTop()
//  }
// }
//
// protocol PublishDelegate: AnyObject {
//  func onPublished()
// }
