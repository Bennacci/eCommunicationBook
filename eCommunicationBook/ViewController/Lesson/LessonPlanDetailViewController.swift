//
//  LessonPlanDetail.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

protocol SavedLessonDelegate: AnyObject {
    
    func onSaved()
}

class LessonPlanDetailViewController: UIViewController, SavedLessonDelegate {
 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelTeacher: UILabel!
    
    var viewModel = LessonPlanDetailViewModel()
    
    weak var delegate: SavedLessonDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: AddRowTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: LessonPlanDetailTableViewCell.identifier, bundle: nil)
        
        viewModel.lessonChanged = { [weak self] () in
        
            self?.tableView.reloadData()
        }
        
        viewModel.onSaved = { [weak self] () in
            
            self?.dismiss(animated: true, completion: nil)
            
            self?.delegate?.onSaved()
        }
        
        layOutView()
    }
    
    func layOutView() {
        
        let calendar = Calendar.current
        
        let date = Date(milliseconds: viewModel.lesson.time).convertToString(dateformat: .dateYMD)
        
        let startTime = Date(milliseconds: viewModel.lesson.time).convertToString(dateformat: .time)
        
        let endDate = calendar.date(byAdding: .minute,
                                    value: viewModel.lesson.timeInterval,
                                    to: Date(milliseconds: viewModel.lesson.time))
        
        let endTime = endDate!.convertToString(dateformat: .time)

        labelDate.text = date
        
        labelTime.text = startTime + " - " + endTime
        
        labelTeacher.text = viewModel.lesson.teacher
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        let controller = UIAlertController(title: "Stop Writing?",
                                           message: "If you go back now you'll lose any changes you've made.",
                                           preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard",
                                          style: .default) { _ in
            
            self.popViewController()
        }
        
        controller.addAction(discardAction)
        
        let saveAction = UIAlertAction(title: "Save Draft",
                                       style: .default) {_ in
            self.viewModel.onSave()
            
            self.popViewController()
        }
        
        controller.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    func popViewController() {
        
        guard let nav = navigationController, nav.topViewController != nil else {
        
            return
        }
        
        nav.popViewController(animated: true)
    }
    
    func onSaved() {
        
        viewModel.onSave()
    }
    
    @objc func saveLessonPlanDetail(_ sender: UIButton) {

        viewModel.onSave()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "lessonPerformances",

           let lPViewController = segue.destination as? LessonPerformancesViewController {

            if sender as? UIButton != nil {

                lPViewController.navigationItem.title = "Students Performances"
                
                lPViewController.delegate = self
                
                lPViewController.viewModel.course = self.viewModel.course
                
                lPViewController.viewModel.currentLesson = self.viewModel.lesson
                
                lPViewController.viewModel.previousLesson = self.viewModel.previousLesson
            }
        }
    }
}

extension LessonPlanDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        switch section {
        
        case 0:
        
            return "Todays's Lesson"
        
        case 1:
        
            return "Today's Homework"
        
        default:
        
            return "Test"
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        
        case 0:
        
            return (viewModel.lesson.todaysLesson?.count ?? 0) + 1
        
        case 1:
        
            return (viewModel.lesson.assignments?.count ?? 0) + 1
        
        default:
        
            return (viewModel.lesson.tests?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var count = 0
        
        switch indexPath.section {
        
        case 0:
        
            count = (viewModel.lesson.todaysLesson?.count ?? 0) + 1
        
        case 1:
        
            count = (viewModel.lesson.assignments?.count ?? 0) + 1
        
        default:
          
            count = (viewModel.lesson.tests?.count ?? 0) + 1
        }
        
        if count == 1 || indexPath.row == count - 1 {
        
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: AddRowTableViewCell.identifier,
                                         for: indexPath) as? AddRowTableViewCell
            
            else {
                
                assertionFailure("AddRowTableViewCell not found")
                
                return UITableViewCell()
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: LessonPlanDetailTableViewCell.identifier,
                                         for: indexPath) as? LessonPlanDetailTableViewCell
            
            else {
                
                assertionFailure("LessonPlanDetailTableViewCell not found")
                
                return UITableViewCell()
            }
            
            cell.textFieldLessonPlanDetail.delegate = self
            
            cell.setUp(lesson: viewModel.lesson, indexPath: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableView.cellForRow(at: indexPath) as? AddRowTableViewCell != nil {
        
            return false
        
        } else {
        
            return true
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            viewModel.onDelColumn(indexPath: indexPath)
        }
    }
}

extension LessonPlanDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        viewModel.onModColumn(indexPath: indexPath)
    }
}

extension LessonPlanDetailViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        
        guard let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable) else {return}
        
        guard let info = textField.text else { return }
        
        viewModel.onChangeContent(indexPath: textFieldIndexPath, text: info)
    }
}
