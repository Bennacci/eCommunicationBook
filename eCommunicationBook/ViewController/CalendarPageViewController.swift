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
  
  fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
    [unowned self] in
    let panGesture = UIPanGestureRecognizer(target: self.calendar,
                                            action: #selector(self.calendar.handleScopeGesture(_:)))
    panGesture.delegate = self
    panGesture.minimumNumberOfTouches = 1
    panGesture.maximumNumberOfTouches = 2
    return panGesture
    }()
  
  override func viewDidLoad() {
    
    
    tableView.registerCellWithNib(identifier: ChartTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: LableWithVerticalLineTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: AssignmentStatusTableViewCell.identifier, bundle: nil)
    super.viewDidLoad()
    
    setCalender()
    
    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    viewModel.dayEventViewModel.bind { [weak self] events in
      //            self?.tableView.reloadData()
      self?.viewModel.onRefresh()
    }
    
    viewModel.dayPerformanceViewModel.bind { [weak self] studenperformances in
      //            self?.tableView.reloadData()
      self?.viewModel.onRefresh()
    }
    
    viewModel.scrollToTop = { [weak self] () in
      
      self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    viewModel.fetchData()
    
    setupRefresher()
  }
  
  func setupRefresher() {
    self.tableView.refresh.header = RefreshHeader(delegate: self)
    
    tableView.refresh.header.addRefreshClosure { [weak self] in
      self?.viewModel.fetchData()
      self?.tableView.refresh.header.endRefreshing()
    }
    
  }
}

extension CalendarPageViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return viewModel.dayPerformanceViewModel.value.count * 2 +
      viewModel.dayEventViewModel.value.count
     
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    let sectionCount = viewModel.dayPerformanceViewModel.value.count * 2 +
    viewModel.dayEventViewModel.value.count
    
    
    if section % 2 == 1 && section != sectionCount {
      return 1
    } else if section != sectionCount {
      let assignmentCompletionCount: Int = viewModel.dayPerformanceViewModel.value[section].assignmentCompleted?.count ?? 0
      let assignmetScoreCount: Int = viewModel.dayPerformanceViewModel.value[section].testGrade?.count ?? 0
//      let performanceCount = viewModel.dayPerformanceViewModel.value[section].
      return assignmentCompletionCount + assignmetScoreCount
    } else {
      return  viewModel.dayEventViewModel.value.count
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "MM/DD 課堂表現"
    case 1:
      return "作業繳交狀況"
    default:
      return "event"
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //      cell.layoutCell(title: viewModel.services[indexPath.section][indexPath.row])
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier,
                                                     for: indexPath) as? ChartTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      return cell
    } else if indexPath.section == 1 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AssignmentStatusTableViewCell.identifier,
                                                     for: indexPath) as? AssignmentStatusTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LableWithVerticalLineTableViewCell.identifier,
                                                     for: indexPath) as? LableWithVerticalLineTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      return cell
    }
    //        if indexPath.section == 0 {
    //            let identifier = ["cell_month", "cell_week"][indexPath.row]
    //            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
    //            return cell
    //        } else {
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    //            return cell
    //        }
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
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    if indexPath == pickerIndexPath && willExpand == true {
      return LableWithVerticalLineTableViewCell.cellHeight()
//    } else {
//      return TwoLablesTableViewCell.cellHeight()
//    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
}

extension CalendarPageViewController: FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
  
  func setCalender() {

    viewModel.onCalendarTaped(day: Date())

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
    
    print("did select date \(Date.dateFormatterYMD.string(from: date))")
    
    let selectedDates = calendar.selectedDates.map({Date.dateFormatterYMD.string(from: $0)})
    
    print("selected dates is \(selectedDates)")
    
    if monthPosition == .next || monthPosition == .previous {
      
      calendar.setCurrentPage(date, animated: true)
    }
  }
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    print("\(Date.dateFormatterYMD.string(from: calendar.currentPage))")
  }
}

extension CalendarPageViewController: RefreshDelegate {
  func refresherDidRefresh(_ refresher: Refresher) {
    print("refresherDidRefresh")
  }
}
