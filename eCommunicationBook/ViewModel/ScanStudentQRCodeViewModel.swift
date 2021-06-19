//
//  ScanStudentQRCodeViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/30.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class ScanStudentQRCodeViewModel {
    
    var courseViewModel = Box([CourseViewModel]())
    
    var lessonList = [String]()
    
    var lessonListChanged: (() -> Void)?
    
    var timeIn: Bool = true {
        
        didSet {
            
            studentExistance.studentName = String.empty
        }
    }
    
    var studentExistance = StudentExistance(
        id: String.empty,
        studentID: String.empty,
        studentName: String.empty,
        time: -1,
        latitude: -1,
        longitude: -1,
        courseName: String.empty,
        courseLesson: 0,
        scanTeacherName: String.empty)
    
    func onScanedAQRCode(info: String) {
        
        if studentExistance.courseName == String.empty || studentExistance.courseLesson == 0 {
            
            BTProgressHUD.showFailure(text: "Please select course name and lesson")
            
            return
        }
        
        let lines = info.components(separatedBy: ":")
        
        if lines.count >= 2 {
            
            if  studentExistance.studentName != lines[0] {
                
                studentExistance.studentName = lines[0]
                
                studentExistance.studentID = lines[1]
                
                if timeIn == true {
                    
                    writeAttendance(with: &studentExistance)
                    
                    writeTimeIn(with: &studentExistance)
                    
                } else {
                    
                    writeTimeOut(with: &studentExistance)
                }
            }
        }
    }
    
    func onCourseNameChanged(index: Int) {
        
        studentExistance.courseName =
            
            courseViewModel.value[index].name + ":" + "\(courseViewModel.value[index].lessonsAmount)"
        
        setLessonList(index: index)
    }
    
    func setLessonList(index: Int?) {
        
        lessonList.removeAll()
        
        if let index = index {
            
            for index in 0 ..< courseViewModel.value[index].lessonsAmount {
                
                lessonList.append(String(index + 1))
            }
        }
        
        self.lessonListChanged?()
    }
    
    func onCourseLessonChanged(index: Int) {
        
        studentExistance.courseLesson = index + 1
    }
    
    func onCurrentLocationChanged(latitude: Double, longitude: Double) {
        
        studentExistance.latitude = latitude
        
        studentExistance.longitude = longitude
    }
    
    var wroteInSuccess: (() -> Void)?
    
    //  var wroteInFailure: (() -> Void)?
    
    var wroteOutSuccess: (() -> Void)?
    
    //  var wroteOutFailure: (() -> Void)?
    
    func writeAttendance(with studentExistance: inout StudentExistance) {
        
        BTProgressHUD.show()
        
        AttendanceManager.shared.writeAttendance(studentExistance: &studentExistance) { result in
            
            BTProgressHUD.dismiss()
            
            switch result {
            
            case .success:
                
                print("onTapPublish, success")
                
            case .failure(let error):
                
                print("writeAttendance.failure: \(error)")
                
            //        self.wroteInFailure?()
            }
        }
    }
    
    func writeTimeIn(with studentExistance: inout StudentExistance) {
        
        BTProgressHUD.show()
        
        AttendanceManager.shared.writeTimeIn(studentExistance: &studentExistance) { result in
            
            BTProgressHUD.dismiss()
            
            switch result {
            
            case .success:
                
                print("writeTimeIn, success")
                
                self.wroteInSuccess?()
                
            case .failure(let error):
                
                print("writeTimeIn.failure: \(error)")
                
            //        self.wroteInFailure?()
            }
        }
    }
    
    func writeTimeOut(with studentExistance: inout StudentExistance) {
        
        BTProgressHUD.show()
        
        AttendanceManager.shared.writeTimeOut(studentExistance: &studentExistance) { result in
            
            BTProgressHUD.dismiss()
            
            switch result {
            
            case .success:
                
                print("onTapPublish, success")
                
                self.wroteOutSuccess?()
                
            case .failure(let error):
                
                print("writeTimeOut.failure: \(error)")
                
            //        self.wroteOutFailure?()
            
            }
        }
    }
    
    func fetchCourse() {
        
        LessonManager.shared.fetchCourses { [weak self] result in
            
            switch result {
            
            case .success(let courses):
                
                self?.searchAndAddLessonsToCourse(courses: courses)
                
            case .failure(let error):
                
                print("fetchCourses.failure: \(error)")
            }
        }
    }
    
    func searchAndAddLessonsToCourse(courses: [Course]) {
        
        var courses = courses
        
        let group: DispatchGroup = DispatchGroup()
        
        for index in 0 ..< courses.count {
            
            let queue = DispatchQueue(label: "queue", attributes: .concurrent)
            
            group.enter()
            
            queue.async(group: group) {
                
                LessonManager.shared.fetchLessons(courseID: courses[index].id) { result in
                    
                    switch result {
                    
                    case .success(let lessons):
                        
                        courses[index].lessons = lessons
                        
                        group.leave()
                        
                    case .failure(let error):
                        
                        print("fetchData.failure: \(error)")
                        
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.setSearchResult(courses)
        }
    }
    
    func convertCoursesToViewModels(from courses: [Course]) -> [CourseViewModel] {
        
        var viewModels = [CourseViewModel]()
        
        for course in courses {
            
            let viewModel = CourseViewModel(model: course)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setSearchResult(_ courses: [Course]) {
        
        courseViewModel.value = convertCoursesToViewModels(from: courses)
    }
}
