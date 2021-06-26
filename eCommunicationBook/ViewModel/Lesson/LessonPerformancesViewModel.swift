//
//  LessonPerformancesViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/28.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

enum LessonPerformancesTitles: String {

    case lessonPerformances = "Lesson Performances"
    
    case homeworkStatus = "Homework Status"
    
    case testsGrade = "Tests Grade"

    case comunicationCorner = "Comunication Corner"
    
    case uploadImage = "Upload Image"
}

class LessonPerformancesViewModel {
    
    var studentLessonRecordsViewModel = Box([StudentLessonRecordViewModel]())
    
    var sectionTitles = [LessonPerformancesTitles.lessonPerformances.rawValue]
    
    var performancesItem = ["Concentration", "Attidtude", "Participant"]
    
    var onSaved: (() -> Void)?
    
    var refreshView: (() -> Void)?
    
    func onRefresh() {

        self.refreshView?()
    }
    
    func uploadImage(with image: UIImage) {
        
        ImageManager.shared.uploadPickerImage(pickerImage: image) { result in
            
            switch result {
            
            case .success(let imageUrl):
                
                self.onImageUploaded(url: imageUrl)
                print("Publish Image Succeeded")
                
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
    }
    func onImageUploaded(url: String) {
     
        if studentLessonRecord.images == nil {
        
            studentLessonRecord.images = []
        
            studentLessonRecord.imageTitles = []
        }
        
        studentLessonRecord.images?.append(url)
        
        studentLessonRecord.imageTitles?.append(String.empty)
        
        onRefresh()
    }
    
    func onDeleteImage(index: Int) {
        
        studentLessonRecord.images?.remove(at: index)
        
        studentLessonRecord.imageTitles?.remove(at: index)
        
        onRefresh()
    }
    
    func onSave() {
        
        self.studentLessonRecordsViewModel.value[studentIndex] =
            StudentLessonRecordViewModel(model: self.studentLessonRecord)
        
        for index in 0 ..< studentLessonRecordsViewModel.value.count {
        
            self.save(with: &studentLessonRecordsViewModel.value[index].studentLessonRecord)
        }
    }
    
    func save(with studentLessonRecord: inout StudentLessonRecord) {
        
        LessonManager.shared.saveStudentLessonRecord(studentLessonRecord: &studentLessonRecord) { result in
            
            switch result {
            
            case .success:
                
                print("onTapPublish, success")
                self.onSaved?()
                
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
    }
    
    var studentIndex = 0
    
    var course: Course = Course(
        id: String.empty,
        name: String.empty,
        teachers: [],
        students: [],
        firstLessonDate: -1,
        courseTime: [],
        fee: -1,
        lessonsAmount: -1,
        lessons: nil)
    
    var previousLesson: Lesson = Lesson(
        id: String.empty,
        number: -1,
        teacher: String.empty,
        time: -1,
        timeInterval: -1,
        todaysLesson: nil,
        tests: nil,
        assignments: nil)
    
    var currentLesson: Lesson = Lesson(
        id: String.empty,
        number: -1,
        teacher: String.empty,
        time: -1,
        timeInterval: -1,
        todaysLesson: nil,
        tests: nil,
        assignments: nil)
    
    var studentLessonRecord: StudentLessonRecord = StudentLessonRecord(
        id: String.empty,
        studentID: String.empty,
        studentName: String.empty,
        courseName: String.empty,
        courseLesson: 0,
        time: -1,
        timeInterval: -1,
        todaysLesson: nil,
        tests: nil,
        assignments: nil,
        performances: [],
        previousTests: nil,
        previousAssignments: nil,
        testGrade: nil,
        assignmentCompleted: nil,
        assignmentScore: nil,
        note: nil,
        images: nil,
        imageTitles: nil)
    
    func onMainCollectionViewInnerScrolled() {
        
        self.studentLessonRecordsViewModel.value[studentIndex] =
            
            StudentLessonRecordViewModel(model: self.studentLessonRecord)
    }
    
    func onMainCollectionViewScrolled(destination index: Int) {
        
        updateStudentLessonRecordsViewModel(index: index)
    }
    
    func updateStudentLessonRecordsViewModel(index: Int) {
        
        let serialQueue = DispatchQueue(label: "scrollItem")
        
        serialQueue.sync {
            
            self.studentLessonRecordsViewModel.value[studentIndex] =
                StudentLessonRecordViewModel(model: self.studentLessonRecord)
        }
        
        serialQueue.sync {
        
            studentLessonRecord = self.studentLessonRecordsViewModel.value[index].studentLessonRecord
            
            studentIndex = index
        }
    }
    
    func onPerformanceSliderSlides(index: Int, value: Int) {

        studentLessonRecord.performances[index] = value
    }
    
    func onAssignmentsStatusToggle(index: Int) {
        
        if (studentLessonRecord.assignmentCompleted?[index])! {
        
            studentLessonRecord.assignmentCompleted?[index] = false
        
        } else {
        
            studentLessonRecord.assignmentCompleted?[index] = true
        }
    }
    
    func onChangeContent(index: Int, text: String) {
    
        if index > 100 {
        
            studentLessonRecord.imageTitles?[index / 100] = text
        
        } else {
        
            studentLessonRecord.testGrade?[index % 100] = text
        }
    }
    
    func onCommunicationCorneChanged(text: String) {
    
        studentLessonRecord.note = text
    }
    
    func setViewModel() {
        
        if previousLesson.assignments != nil {
        
            sectionTitles.append(LessonPerformancesTitles.homeworkStatus.rawValue)
        }
        
        if previousLesson.tests != nil {
            
            sectionTitles.append(LessonPerformancesTitles.testsGrade.rawValue)
        }
        
        sectionTitles.append(LessonPerformancesTitles.comunicationCorner.rawValue)
        
        sectionTitles.append(LessonPerformancesTitles.uploadImage.rawValue)
        
        studentLessonRecord.courseLesson = currentLesson.number
        
        studentLessonRecord.courseName = course.name + ":" + "\(course.lessonsAmount)"
        
        studentLessonRecord.time = currentLesson.time
        
        studentLessonRecord.timeInterval = currentLesson.timeInterval
        
        studentLessonRecord.todaysLesson = currentLesson.todaysLesson
        
        studentLessonRecord.tests = currentLesson.tests
        
        studentLessonRecord.assignments = currentLesson.assignments
        
        studentLessonRecord.performances = performancesItem.map({ _ in 3 })
        
        if let assignments = previousLesson.assignments {
        
            studentLessonRecord.assignmentCompleted = assignments.map({ _ in false })
        }
        
        if let assignments = previousLesson.assignments {
            
            studentLessonRecord.previousAssignments = assignments
            
            studentLessonRecord.assignmentCompleted = assignments.map({ _ in false })
        }
        
        if let tests = previousLesson.tests {
        
            studentLessonRecord.previousTests = tests
            
            studentLessonRecord.testGrade = tests.map({ _ in String.empty })
        }
                
        studentLessonRecordsViewModel.value = scaleViewModels(with: self.course)
        
        studentLessonRecord = studentLessonRecordsViewModel.value[0].studentLessonRecord
    }
    
    func scaleViewModels(with course: Course) -> [StudentLessonRecordViewModel] {
        
        var viewModels = [StudentLessonRecordViewModel]()
        
        for student in course.students {
            
            let info = student.components(separatedBy: ":")
            
            let name = info[0]
            
            let identity = info[1]
            
            studentLessonRecord.studentID = identity
            
            studentLessonRecord.studentName = name
            
            let courseInfo = course.name.components(separatedBy: ":")
            
            studentLessonRecord.courseName = courseInfo[0]
            
            let viewModel = StudentLessonRecordViewModel(model: studentLessonRecord)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
}
