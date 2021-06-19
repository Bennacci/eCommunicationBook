//
//  AttendanceSheetViewModel.swift
//
//
//  Created by Ben Tee on 2021/6/4.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class AttendanceSheetViewModel {
    
    var courseViewModel = Box([CourseViewModel]())
    
    var studentAttendancesViewModel = Box([[StudentExistanceViewModel]]())
    
    var selectedCourseIndex: Int?
    
    var nameIndexDic = [String.empty: 0]
    
    var columns = [String.empty]

    var contentSet: (() -> Void)?
    
    var rows = [[String]]()
    
    func setAttendanceSheetContent() {
        
        columns = ["name"]
        
        guard let selectedCourseIndex = selectedCourseIndex else { return }
        
        let lessonAmount = courseViewModel.value[selectedCourseIndex].lessonsAmount
        
        for index in 0 ..< lessonAmount {
            
            let lessonNo = "\(index+1)"
            
            guard let time = courseViewModel.value[selectedCourseIndex].lessons?[index].time else { return }
            
            let date = Date(milliseconds: time).convertToString(dateformat: .dateMD)
            
            columns.append(lessonNo + ". " + date)
        }
        
        columns.append("rate")
        
        rows.removeAll()
        
        nameIndexDic.removeAll()
        
        for studentIndex in 0 ..< studentAttendancesViewModel.value[0].count {
            
            let name = studentAttendancesViewModel.value[0][studentIndex].studentName
            
            rows.append([name])
            
            nameIndexDic[name] = studentIndex
        }
        
        for lessonIndex in 1 ..< studentAttendancesViewModel.value.count {
            
            for studentIndex in 0 ..< studentAttendancesViewModel.value[lessonIndex].count {
                
                let name = studentAttendancesViewModel.value[lessonIndex][studentIndex].studentName
                
                guard let studentRowIndex = nameIndexDic[name] else {return}
                
                guard let time = courseViewModel
                        .value[selectedCourseIndex]
                        .lessons?[lessonIndex - 1]
                        .time else { return }
                
                guard let timeInterval = courseViewModel
                        .value[selectedCourseIndex]
                        .lessons?[lessonIndex - 1]
                        .timeInterval else { return }
                
                rows[studentRowIndex].append("❌")
                
                if studentAttendancesViewModel.value[lessonIndex][studentIndex].time < time {
                    
                    rows[studentRowIndex][lessonIndex] = "✅"
                    
                } else if studentAttendancesViewModel.value[lessonIndex][studentIndex].time > time {
                    
                    rows[studentRowIndex][lessonIndex] = "☑️"
                }
            }
        }
        
        for index in 0 ..< rows.count {
            
            var rate = 0.0
            
            for subIndex in 1 ..< rows[index].count {
                
                if rows[index][subIndex] == "✅" {
                    
                    rate += 1.0
                    
                } else if rows[index][subIndex] == "☑️" {
                    
                    rate += 0.5
                }
            }
            
            let rateString = "\((rate / Double(rows[index].count - 1) * 100).rounded())%"
            
            for _ in 0 ..< columns.count - rows[index].count - 1 {
                
                rows[index].append(String.empty)
            }
            
            rows[index].append(rateString)
        }
        
        self.contentSet?()
    }
    
    func onCourseNameChanged(index: Int) {
        
        selectedCourseIndex = index
        
        let name = courseViewModel.value[index].name
        
        let count = "\(courseViewModel.value[index].lessonsAmount)"
        
        let courseInfo = name + ":" + count
        
        fetchAttendace(courseName: courseInfo)
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
    
    func fetchAttendace(courseName: String) {
        
        AttendanceManager.shared.fetchAttendance(courseName: courseName) { [weak self] result in
            
            switch result {
            
            case .success(let attendaces):
                
                self?.setStudentAttendances(with: attendaces)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func convertStudentExistancesToViewModels(from recordss: [[StudentExistance]]) -> [[StudentExistanceViewModel]] {
        
        var viewModelss = [[StudentExistanceViewModel]]()
        
        for records in recordss {
            
            var viewModels = [StudentExistanceViewModel]()
            
            for record in records {
                
                let viewModel = StudentExistanceViewModel(model: record)
                
                viewModels.append(viewModel)
            }
            
            viewModelss.append(viewModels)
        }
        
        return viewModelss
    }
    
    func setStudentAttendances(with records: [[StudentExistance]]) {
        
        studentAttendancesViewModel.value = convertStudentExistancesToViewModels(from: records)
    }
}
