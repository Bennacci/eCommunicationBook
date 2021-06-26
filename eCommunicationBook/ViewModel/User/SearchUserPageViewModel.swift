//
//  SearchUserPageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class SearchUserPageViewModel {
    
    let userViewModel = Box([UserViewModel]())
    
    let userListViewModel = Box([UserViewModel]())
    
    let studentViewModel =  Box([StudentViewModel]())
    
    let studentListViewModel =  Box([StudentViewModel]())
    
    var refreshView: (() -> Void)?
    
    var scrollToTop: (() -> Void)?
    
    var tapUser: (() -> Void)?
    
    var forCreateChatRoom = false
    
    var friendList: [String]?
    
    var forStudent = false
    
    func fetchData() {
        
        if forStudent == false {
            
            UserManager.shared.fetchUsers { [weak self] result in
                
                switch result {
                
                case .success(let users):
                    
                    self?.setSearchResult(users)
                    
                case .failure(let error):
                    
                    print("fetchUser.failure: \(error)")
                }
            }
            
        } else {
            
            StudentManager.shared.fetchStudents { [weak self] result in
                
                switch result {
                
                case .success(let students):
                    
                    self?.setSearchResult(students)
                    
                case .failure(let error):
                    
                    print("fetchStudents.failure: \(error)")
                }
            }
        }
    }
    
    func onSendAndQuit() {
        
        if forStudent == false {
            
            UserManager.shared.selectedUsers = userListViewModel.value
            
        } else {
            
            UserManager.shared.selectedStudents = studentListViewModel.value
        }
        
        if forCreateChatRoom == true {
            
            guard let users = UserManager.shared.selectedUsers else {return}
            
            for user in users {
                
                var chatRoom = ChatRoom(id: String.empty,
                                        members: [UserManager.shared.user.id, user.id],
                                        createdTime: -1,
                                        messages: nil
                )
                
                ChatroomManager.shared.publishChatroom(chatRoom: &chatRoom) { result in
                    
                    switch result {
                    
                    case .success( _):
                        
                        UserManager.shared.selectedUsers?.removeAll()
                        
                        print("Chatroom created")
                        
                    case .failure(let error):
                        
                        print("publishChatroom.failure: \(error)")
                    }
                }
            }
        }
    }
    
    func onRefresh() {

        self.refreshView?()
    }
    
    func onScrollToTop() {
        
        self.scrollToTop?()
    }
    
    func addSelectedToList(index: Int) {
        
        if forStudent == false {
            
            setUserSelected(userViewModel.value[index])
            
        } else {
            
            setStudentSelected(studentViewModel.value[index])
        }
    }
    
    func removeSelectedFromList(index: Int) {
        
        if forStudent == false {
            
            setUserDeselected(userViewModel.value[index])
            
        } else {
            
            setStudentDeselected(studentViewModel.value[index])
        }
    }
    
    func removeSelectedFromList(collectionIndex: Int) {
        
        if forStudent == false {
            
            setUserDeselected(userListViewModel.value[collectionIndex])
            
        } else {
            
            setStudentDeselected(studentListViewModel.value[collectionIndex])
        }
    }
    
    func convertUserToViewModels(from users: [User]) -> [UserViewModel] {
        
        var viewModels = [UserViewModel]()
        
        for user in users {
            
            let viewModel = UserViewModel(model: user)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func convertStudentToViewModels(from students: [Student]) -> [StudentViewModel] {
        
        var viewModels = [StudentViewModel]()
        
        for student in students {
            
            let viewModel = StudentViewModel(model: student)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setSearchResult(_ users: [User]) {
        
        var userList = users
        
        if forCreateChatRoom {
            
            userList = users.filter({$0.id != UserManager.shared.user.id})
            
            guard let friendList = friendList else {return}
            
            for friend in friendList {
                
                userList = userList.filter({$0.id != friend})
            }
        }
        
        userViewModel.value = convertUserToViewModels(from: userList)
        
        userListViewModel.value = UserManager.shared.selectedUsers ?? []
    }
    
    func setSearchResult(_ students: [Student]) {
        
        studentViewModel.value = convertStudentToViewModels(from: students)
        
        studentListViewModel.value = UserManager.shared.selectedStudents ?? []
    }
    
    func addUserToViewModels(with user: UserViewModel) -> [UserViewModel] {
        
        var viewModels = userListViewModel.value
        
        viewModels.append(user)
        
        return viewModels
    }
    
    func setUserSelected(_ user: UserViewModel) {
        
        userListViewModel.value = addUserToViewModels(with: user)
    }
    
    func removeUsefromViewModels(with user: UserViewModel) -> [UserViewModel] {
        
        let oldViewModels = userListViewModel.value
        
        var newViewModels = [UserViewModel]()
        
        newViewModels = oldViewModels.filter({$0.id != user.id})
        
        return newViewModels
    }
    
    func setUserDeselected(_ user: UserViewModel) {
        
        userListViewModel.value = removeUsefromViewModels(with: user)
    }
    
    func addStudentToViewModels(with student: StudentViewModel) -> [StudentViewModel] {
        
        var viewModels = studentListViewModel.value
        
        viewModels.append(student)
        
        return viewModels
    }
    
    func setStudentSelected(_ student: StudentViewModel) {
        
        studentListViewModel.value = addStudentToViewModels(with: student)
    }
    
    func removeStudentfromViewModels(with student: StudentViewModel) -> [StudentViewModel] {
        
        let oldViewModels = studentListViewModel.value
        
        var newViewModels = [StudentViewModel]()
        
        newViewModels = oldViewModels.filter({$0.id != student.id})
        
        return newViewModels
    }
    
    func setStudentDeselected(_ student: StudentViewModel) {
        
        studentListViewModel.value = removeStudentfromViewModels(with: student)
    }
}
