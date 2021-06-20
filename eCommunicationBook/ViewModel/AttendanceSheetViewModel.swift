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

//    var contentSet: (() -> Void)?
    
    var refreshView: (() -> Void)?
    
    var rows = [[String]]()
    
    func contentSet() {
        
        self.refreshView?()
    }
    
    func setAttendanceSheetContent() {
                
        guard let selectedCourseIndex = selectedCourseIndex else { return }

        configColumns(with: selectedCourseIndex)
        
        configRows(with: selectedCourseIndex)
                
        self.contentSet()
    }
    
    func configColumns(with selectedCourseIndex: Int) {
        
        columns = ["name"]

        let lessonAmount = courseViewModel.value[selectedCourseIndex].lessonsAmount
        
        for index in 0 ..< lessonAmount {
            
            let lessonNo = "\(index+1)"
            
            guard let time = courseViewModel.value[selectedCourseIndex].lessons?[index].time else { return }
            
            let date = Date(milliseconds: time).convertToString(dateformat: .dateMD)
            
            columns.append(lessonNo + ". " + date)
        }
        
        columns.append("rate")
    }
    
    func configRows(with selectedCourseIndex: Int) {
        
        rows.removeAll()
        
        nameIndexDic.removeAll()
        
        for studentIndex in 0 ..< studentAttendancesViewModel.value[0].count {
            
            let name = studentAttendancesViewModel.value[0][studentIndex].studentName
            
            rows.append([name])
            
            nameIndexDic[name] = studentIndex
        }
        
        calculateAttendanceStatus(with: selectedCourseIndex)
        
        calculateAttendanceRate()
    }
    
    func calculateAttendanceStatus(with selectedCourseIndex: Int) {
        
        let onTimeTolerance: Double = 5 * 60 * 1000
        
        for lessonIndex in 1 ..< studentAttendancesViewModel.value.count {
            
            guard let time = courseViewModel
                    .value[selectedCourseIndex]
                    .lessons?[lessonIndex - 1]
                    .time else { return }
            
            guard let timeInterval = courseViewModel
                    .value[selectedCourseIndex]
                    .lessons?[lessonIndex - 1]
                    .timeInterval else { return }
            
            // Set attendance to absence if lesson has started
            if Date().millisecondsSince1970 >= time {
                
                for studentIndex in 0 ..< studentAttendancesViewModel.value[0].count {
                
                    rows[studentIndex].append("❌")
                }
            }
            
            for studentIndex in 0 ..< studentAttendancesViewModel.value[lessonIndex].count {
                                
                let name = studentAttendancesViewModel.value[lessonIndex][studentIndex].studentName
                
                guard let studentRowIndex = nameIndexDic[name] else {return}
                
                let lessonEndTime = time + Double(timeInterval) * 60 * 1000
                
                // Change attendance status to ✅ or ☑️, if the student has any attendance record before the lesson ends.
                if studentAttendancesViewModel.value[lessonIndex][studentIndex].time <= time + onTimeTolerance {
                    
                    rows[studentRowIndex][lessonIndex] = "✅"
                    
                } else if studentAttendancesViewModel.value[lessonIndex][studentIndex].time < lessonEndTime {
                    
                    rows[studentRowIndex][lessonIndex] = "☑️"
                }
            }
        }
    }
    
    func calculateAttendanceRate() {
        
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
