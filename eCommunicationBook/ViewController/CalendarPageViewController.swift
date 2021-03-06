//
//  CalendarPage.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/14.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import FSCalendar
import EasyRefresher

class CalendarPageViewController: UIViewController {
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendar: FSCalendar!
    //    @IBOutlet weak var animationSwitch: UISwitch!
    
    let viewModel = CalendarPageViewModel()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
       
        let panGesture = UIPanGestureRecognizer(target: self.calendar,
                                                action: #selector(self.calendar.handleScopeGesture(_:)))
        
        panGesture.delegate = self
        
        panGesture.minimumNumberOfTouches = 1
        
        panGesture.maximumNumberOfTouches = 2
        
        return panGesture
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: ChartTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: LableWithVerticalLineTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: AssignmentStatusTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: TodaysLesoonTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: StudentExistancesTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: StudentImagesTableViewCell.identifier, bundle: nil)
        
        viewModel.fetchData()
        
        setCalendar()
        
        viewModel.refreshView = { [weak self] () in
     
            DispatchQueue.main.async {
            
                self?.tableView.reloadData()
            }
        }
        
        viewModel.scrollToTop = { [weak self] () in
            
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        setupRefresher()
        
        viewModel.eventViewModel.bind { [weak self] _ in
            
            let date = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            
            guard let date = Calendar.current.date(from: date) else {return}
            
            self?.viewModel.onCalendarTapped(day: date)
        }
    }
    
    func setupRefresher() {
        
        self.tableView.refresh.header = RefreshHeader(delegate: self)
        
        tableView.refresh.header.addRefreshClosure { [weak self] in

            self?.tableView.refresh.header.endRefreshing()
        }
    }
}

extension CalendarPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let title = viewModel.titles[section]
        
        switch title {
        
        case CalendarPageTitles.events.rawValue:
        
            return viewModel.dayEventViewModel.value.count
        
        case CalendarPageTitles.communicationBook.rawValue:

            return viewModel.comunicationSectionTitles.count
        
        case CalendarPageTitles.studentAttendanceAndLeave.rawValue:

            return 1
        
        default:
        
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        let myLabel = UILabel()
        
        myLabel.frame = CGRect(x: 16, y: headerView.frame.height / 4, width: tableView.bounds.size.width, height: 30)
        
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        headerView.addSubview(myLabel)
        
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return viewModel.titles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let title = viewModel.titles[indexPath.section]
        
        switch title {
        
        case CalendarPageTitles.events.rawValue:

            let cell: LableWithVerticalLineTableViewCell = tableView.dequeueReusableCell(for: indexPath)

            cell.setUp(viewModel: viewModel.dayEventViewModel.value[indexPath.row])
            
            return cell
            
        case CalendarPageTitles.communicationBook.rawValue:

            let title = viewModel.comunicationSectionTitles[indexPath.row]
            
            if title == ComunicationSectionTitles.lessonPerformances.rawValue {
                
                let cell: ChartTableViewCell = tableView.dequeueReusableCell(for: indexPath)

                cell.setUp(viewModel: viewModel.dayLessonRecordViewModel.value[0])
                
                return cell
                
            } else if title == ComunicationSectionTitles.studentImages.rawValue {
                
                let cell: StudentImagesTableViewCell = tableView.dequeueReusableCell(for: indexPath)

                cell.setUp(viewModel: viewModel.dayLessonRecordViewModel.value[0],
                           index: indexPath.row - viewModel.comunicationSectionTitles.count + 2)
                
                return cell
                
            } else {
                
                let cell: TodaysLesoonTableViewCell = tableView.dequeueReusableCell(for: indexPath)

                cell.setUp(viewModel: viewModel.dayLessonRecordViewModel.value[0], title: title)
                
                return cell
            }
            
        default:

            let cell: StudentExistancesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            var timeOutViewModel: StudentExistanceViewModel?
            
            if indexPath.row < viewModel.dayStudentTimeOutViemModel.value.count {
                
                timeOutViewModel = viewModel.dayStudentTimeOutViemModel.value[indexPath.row]
            }
            
            cell.setUp(forCalendar: true,
                       timeInViewModel: viewModel.dayStudentTimeInViemModel.value[indexPath.row],
                       timeOutViewModel: timeOutViewModel)
            
            return cell
        }
    }
}

extension CalendarPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
        
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            
            self.calendar.setScope(scope, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 32
    }
}

extension CalendarPageViewController: FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    func setCalendar() {
        
        if UIDevice.current.model.hasPrefix("iPad") {
            
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.calendar.scope = .month
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        
        if shouldBegin {
        
            let velocity = self.scopeGesture.velocity(in: self.view)
            
            switch self.calendar.scope {
            
            case .month:
            
                return velocity.y < 0
            
            case .week:
            
                return velocity.y > 0
            
            @unknown default:
            
                break
            }
        }
        
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.calendarHeightConstraint.constant = bounds.height
        
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        tableView.reloadInputViews()
        
        print("did select date " + date.convertToString(dateformat: .dateYMD) )
        
        viewModel.onCalendarTapped(day: date)
        
        let selectedDates = calendar.selectedDates.map({$0.convertToString(dateformat: .dateYMD)})
        
        print("selected dates is \(selectedDates)")
        
        if monthPosition == .next || monthPosition == .previous {
            
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print(calendar.currentPage.convertToString(dateformat: .dateYMD))
    }
}

extension CalendarPageViewController: RefreshDelegate {
    
    func refresherDidRefresh(_ refresher: Refresher) {
    
        print("refresherDidRefresh")
    }
}
