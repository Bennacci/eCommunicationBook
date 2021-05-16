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

    var refreshView: (()->())?
    
    var scrollToTop: (()->())?
    
    func fetchData() {
        
        XXXManager.shared.fetchChatrooms { [weak self] result in
            
            switch result {
            
            case .success(let chatrooms):
                
                self?.setChatRooms(chatrooms)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
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
