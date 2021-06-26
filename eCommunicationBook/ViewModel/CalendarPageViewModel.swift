//
//  CalendarPageViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

enum CalendarPageTitles: String {
    case events = "Events"
    case communicationBook = "Communication Book"
    case studentAttendanceAndLeave = "Student Attendance and Leave"
}

enum ComunicationSectionTitles: String {
    case todaysLesson = "Today's Lesson"
    case lessonPerformances = "Lesson Performances"
    case homework = "Homework"
    case test = "Test"
    case homeworkScore = "Homework Score"
    case testsScore = "Tests Score"
    case studentImages = "Student Images"
    case communicationCorner = "Communication Corner"
}

class CalendarPageViewModel {
    
    var titles: [String] = []
    
    var comunicationSectionTitles: [String] = []
    
    var lessonImageIndex = 0
    
    let eventViewModel = Box([EventViewModel]())
    
    let lessonRecordViewModel = Box([StudentLessonRecordViewModel]())
    
    let studentTimeInViemModel = Box([StudentExistanceViewModel]())
    
    let studentTimeOutViemModel = Box([StudentExistanceViewModel]())
    
    var refreshView: (() -> Void)?
    
    var scrollToTop: (() -> Void)?
    
    var tap: (() -> Void)?
    
    var yearMonth = Calendar.current.dateComponents([.year, .month], from: Date())
    
    var dayEventViewModel = Box([EventViewModel]())
    
    var dayLessonRecordViewModel = Box([StudentLessonRecordViewModel]())
    
    let dayStudentTimeInViemModel = Box([StudentExistanceViewModel]())
    
    let dayStudentTimeOutViemModel = Box([StudentExistanceViewModel]())
    
    func onRefresh() {

        self.refreshView?()
    }
    
    func onScrollToTop() {
        
        self.scrollToTop?()
    }
        
    func onCalendarTapped(day: Date) {
        
        let tappedYearMonth = Calendar.current.dateComponents([.year, .month], from: day)
        
        if tappedYearMonth != yearMonth {
            
            yearMonth = tappedYearMonth
            
            fetchExistances(date: day)
        }
        
        let time = Double(day.millisecondsSince1970)
        
        let milliSecondsPerDay = Double(CalendarHelper.shared.milliSecondsPerDay)
        
        dayEventViewModel.value = eventViewModel.value.filter({
            
            $0.date >= time &&
                
                $0.date <= time + milliSecondsPerDay - 1
            
        })
        
        dayLessonRecordViewModel.value = lessonRecordViewModel.value.filter({
            
            $0.time >= time &&
                
                $0.time <= time + milliSecondsPerDay - 1
        })
        
        dayStudentTimeInViemModel.value = studentTimeInViemModel.value.filter({
            
            $0.time >= time &&
                
                $0.time <= time + milliSecondsPerDay - 1
        })
        
        dayStudentTimeOutViemModel.value = studentTimeOutViemModel.value.filter({
            
            $0.time >= time &&
                
                $0.time <= time + milliSecondsPerDay - 1
        })
        
        setTitle()
        
        setComunicationSectionTitle()
        
        onRefresh()
    }
    
    func setComunicationSectionTitle() {
        
        lessonImageIndex = 0
        
        comunicationSectionTitles = [ComunicationSectionTitles.todaysLesson.rawValue,
                                     ComunicationSectionTitles.lessonPerformances.rawValue]
        
        if dayLessonRecordViewModel.value.isEmpty != true {
            
            if dayLessonRecordViewModel.value[0].assignments != nil {
                
                comunicationSectionTitles.append(ComunicationSectionTitles.homework.rawValue)
            }
            
            if dayLessonRecordViewModel.value[0].tests != nil {
                
                comunicationSectionTitles.append(ComunicationSectionTitles.test.rawValue)
            }
            
            if dayLessonRecordViewModel.value[0].assignmentCompleted != nil {
                
                comunicationSectionTitles.append(ComunicationSectionTitles.homeworkScore.rawValue)
            }
            
            if dayLessonRecordViewModel.value[0].testGrade != nil {
            
                comunicationSectionTitles.append(ComunicationSectionTitles.testsScore.rawValue)
            }
            
            if dayLessonRecordViewModel.value[0].imageTitles != nil {
            
                comunicationSectionTitles.append(ComunicationSectionTitles.studentImages.rawValue)
            }
            
            if dayLessonRecordViewModel.value[0].note != nil {
                
                comunicationSectionTitles.append(ComunicationSectionTitles.communicationCorner.rawValue)
            }
        }
    }
    
    func setTitle() {
        
        titles = []
        
        if dayEventViewModel.value.isEmpty != true {
            
            titles.append(CalendarPageTitles.events.rawValue)
        }
        
        if dayLessonRecordViewModel.value.isEmpty != true {
            
            titles.append(CalendarPageTitles.communicationBook.rawValue)
        }
        
        if dayStudentTimeInViemModel.value.isEmpty != true {
            
            titles.append(CalendarPageTitles.studentAttendanceAndLeave.rawValue)
        }
    }
    
    func fetchData() {
        
        fetchExistances(date: nil)
        
        EventManager.shared.fetchEvents { [weak self] result in
            
            switch result {
            
            case .success(let events):
                
                self?.setEvents(events)
                
            case .failure(let error):
                
                print("fetchEvents.failure: \(error)")
            }
        }
        
        LessonManager.shared.fetchStudentLessonRecord { [weak self] result in
            
            switch result {
            
            case .success(let studentLessonRecords):
                
                self?.setStudentLessonRecords(studentLessonRecords)
                            
            case .failure(let error):
                
                print("fetchStudentLessonRecord.failure: \(error)")
            }
        }
    }
    
    func fetchExistances(date: Date?) {
        
        var selectedDate = Date()
        
        if let date = date {
            
            selectedDate = date
        }
        
        AttendanceManager.shared.fetchStudentExistances(studentIndex: 0,
                                                        date: selectedDate,
                                                        timeIn: true) { [weak self] result in
            
            switch result {
            
            case .success(let studentExistances):
                
                self?.setStudentExistances(studentExistances, timeIn: true)
                            
            case .failure(let error):
                
                print("fetchStudentExistances.failure: \(error)")
            }
        }
        
        AttendanceManager.shared.fetchStudentExistances(studentIndex: 0,
                                                        date: selectedDate,
                                                        timeIn: false) { [weak self] result in
            
            switch result {
            
            case .success(let studentExistances):
                
                self?.setStudentExistances(studentExistances, timeIn: false)
                            
            case .failure(let error):
                
                print("fetchStudentExistances.failure: \(error)")
            }
        }
    }
    
    func convertEventsToViewModels(from events: [Event]) -> [EventViewModel] {
       
        var viewModels = [EventViewModel]()
        
        for event in events {
        
            let viewModel = EventViewModel(model: event)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setEvents(_ events: [Event]) {
        
        eventViewModel.value = convertEventsToViewModels(from: events)
    }
    
    func convertStudenLessonRecordsToViewModels(from records: [StudentLessonRecord]) -> [StudentLessonRecordViewModel] {
        
        var viewModels = [StudentLessonRecordViewModel]()
        
        for record in records {
        
            let viewModel = StudentLessonRecordViewModel(model: record)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setStudentLessonRecords(_ records: [StudentLessonRecord]) {
        
        lessonRecordViewModel.value = convertStudenLessonRecordsToViewModels(from: records)
    }
    
    func convertStudentExistancesToViewModels(from records: [StudentExistance]) -> [StudentExistanceViewModel] {
        
        var viewModels = [StudentExistanceViewModel]()
        
        for record in records {
        
            let viewModel = StudentExistanceViewModel(model: record)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setStudentExistances(_ records: [StudentExistance], timeIn: Bool) {
        if timeIn == true {
            
            studentTimeInViemModel.value = convertStudentExistancesToViewModels(from: records)
        
        } else {
        
            studentTimeOutViemModel.value = convertStudentExistancesToViewModels(from: records)
        }
    }
}
