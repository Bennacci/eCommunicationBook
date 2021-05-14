//
//  CalendarPage.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/14.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarPageViewController: UIViewController {
  
  @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var calendar: FSCalendar!
  //    @IBOutlet weak var animationSwitch: UISwitch!
  
  fileprivate lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
  }()
  
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
    super.viewDidLoad()
    setCalender()
  }
//  @IBAction func toggleClicked(sender: AnyObject) {
//    if self.calendar.scope == .month {
//      //            self.calendar.setScope(.week, animated: self.animationSwitch.isOn)
//    } else {
//      //            self.calendar.setScope(.month, animated: self.animationSwitch.isOn)
//    }
//  }
}

extension CalendarPageViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return [2, 20][section]
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarChartTableViewCell.identifier,
                                                   for: indexPath) as? CalendarChartTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    //      cell.layoutCell(title: viewModel.services[indexPath.section][indexPath.row])
    return cell
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
}

extension CalendarPageViewController: FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {

  func setCalender(){
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
    print("did select date \(self.dateFormatter.string(from: date))")
    let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
    print("selected dates is \(selectedDates)")
    if monthPosition == .next || monthPosition == .previous {
      calendar.setCurrentPage(date, animated: true)
    }
  }
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    print("\(self.dateFormatter.string(from: calendar.currentPage))")
  }
}
