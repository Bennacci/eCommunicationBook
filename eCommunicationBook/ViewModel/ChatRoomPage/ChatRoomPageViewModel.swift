//
//  ChatRoomPageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ChatRoomPageViewModel {
    
    let chatRoomViewModel = Box([ChatRoomViewModel]())
    
    var refreshView: (() -> Void)?
    
    var scrollToTop: (() -> Void)?
    
    func fetchData() {
        
        ChatroomManager.shared.fetchChatrooms { [weak self] result in
            
            switch result {
            
            case .success(let chatRooms):
                
                self?.searchAndAddConversationToChatRoom(chatRooms: chatRooms)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func searchAndAddConversationToChatRoom(chatRooms: [ChatRoom]) {
        
        var chatRooms = chatRooms
        
        let group: DispatchGroup = DispatchGroup()
        
        for index in 0 ..< chatRooms.count {
            
            let queue = DispatchQueue(label: "queue", attributes: .concurrent)
            
            group.enter()
            
            queue.async(group: group) {
                
                ChatroomManager.shared.fetchMessages(chatRoomID: chatRooms[index].id) { result in
                    
                    switch result {
                    
                    case .success(let messages):
                        
                        chatRooms[index].messages = messages
                        
                        group.leave()
                        
                    case .failure(let error):
                        
                        print("fetchData.failure: \(error)")
                        
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.setChatRooms(chatRooms)
        }
    }
    
    func onRefresh() {
        // maybe do something
        self.refreshView?()
    }
    
    func onScrollToTop() {
        
        self.scrollToTop?()
    }
    
    func onTap(withIndex index: Int) {
        
        chatRoomViewModel.value[index].onTap()
    }
    
    func convertChatRoomsToViewModels(from chatRooms: [ChatRoom]) -> [ChatRoomViewModel] {
        
        var viewModels = [ChatRoomViewModel]()
        
        for chatRoom in chatRooms {
            
            let viewModel = ChatRoomViewModel(model: chatRoom)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setChatRooms(_ chatRooms: [ChatRoom]) {
        
        chatRoomViewModel.value = convertChatRoomsToViewModels(from: chatRooms)
    }
}
