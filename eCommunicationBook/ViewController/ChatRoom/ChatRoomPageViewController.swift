//
//  ChatRoomPageViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import EasyRefresher

class ChatRoomPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonCreateChatRoom: UIButton!
    
    let viewModel = ChatRoomPageViewModel()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = .blue
        
        self.navigationItem.title = "Chats"
        
        viewModel.refreshView = { [weak self] () in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
            }
            
            if UserManager.shared.user.userType == UserType.parents.rawValue {
                
                self?.buttonCreateChatRoom.isHidden = true
            }
        }
        
        viewModel.chatRoomViewModel.bind { [weak self] _ in
            
            self?.viewModel.onRefresh()
        }
        
        viewModel.scrollToTop = { [weak self] () in
            
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        setupRefresher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.fetchData()
    }
    
    func setupRefresher() {
        
        self.tableView.refresh.header = RefreshHeader(delegate: self)
        
        tableView.refresh.header.addRefreshClosure { [weak self] in
            
            self?.viewModel.fetchData()
            
            self?.tableView.refresh.header.endRefreshing()
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        if let nextVC = UIStoryboard.searchUser.instantiateInitialViewController() {
            
            guard let targetController = nextVC.children[0] as? SearchUserViewController
            
            else {
                
                assertionFailure("SearchUserViewController as nextVC not found")
                
                return
            }
            
            targetController.viewModel.forCreateChatRoom = true
            
            var friendList: [String] = []
            
            for index in 0 ..< viewModel.chatRoomViewModel.value.count {
                
                let otherUser =
                    
                    viewModel.chatRoomViewModel.value[index].members.filter({$0 != UserManager.shared.user.id})
                
                if otherUser.count > 0 {
                    
                    friendList.append(otherUser[0])
                }
            }
            
            targetController.viewModel.friendList = friendList
            
            self.navigationController?.show(nextVC, sender: nil)
            
        } else { return }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ConversationPage",
           
           let conversationViewController = segue.destination as? ConversationViewController {
            
            if let indexPath = sender as? IndexPath {
                
                let otherUser =
                    viewModel.chatRoomViewModel.value[indexPath.row].members.filter({$0 != UserManager.shared.user.id})
                
                if otherUser.count > 0 {
                    
                    conversationViewController.viewModel.otherUserID = otherUser[0]
                }
            }
        }
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
        
        chatRoomTableViewCell.setup(viewModel: cellViewModel, index: indexPath.row)
        
        return chatRoomTableViewCell
    }
}

extension ChatRoomPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ConversationPage", sender: indexPath)
        
        viewModel.onTap(withIndex: indexPath.row)
    }
}

extension ChatRoomPageViewController: RefreshDelegate {
    
    func refresherDidRefresh(_ refresher: Refresher) {
        
        print("refresherDidRefresh")
    }
}
