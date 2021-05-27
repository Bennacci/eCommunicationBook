//
//  LessonPlanDetail.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

protocol SavedLessonDelegate {
  func onSaved()
}

class LessonPlanDetailViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var labelLessonTitle: UILabel!
  @IBOutlet weak var textFieldDate: UITextField!
  @IBOutlet weak var textFieldTeacher: UITextField!
  
  var viewModel = LessonPlanDetailViewModel()
  
  var delegate: SavedLessonDelegate?
  
  let publishBV: SaveButtonView = {
    let view = SaveButtonView()
    view.frame = CGRect(x: UIScreen.main.bounds.width - 66,
                        y: UIScreen.main.bounds.height - 126,
                        width: 50,
                        height: 50)
    view.backgroundColor = .clear
    view.initSubView()
    view.saveButton.addTarget(self, action: #selector(saveLessonPlanDetail), for: .touchUpInside)
    return view
  }()
  
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
    labelLessonTitle.text = "Lesson \(viewModel.lesson.number)"
    addSaveButton()
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func addSaveButton() {
    self.view.addSubview(publishBV)
  }
  
  @objc func saveLessonPlanDetail(_ sender: UIButton) {
    viewModel.onSave()
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
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRowTableViewCell.identifier,
                                                     for: indexPath) as? AddRowTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      return cell
      
    } else {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonPlanDetailTableViewCell.identifier,
                                                     for: indexPath) as? LessonPlanDetailTableViewCell
        else { fatalError("Unexpected Table View Cell") }
//      cell.isUserInteractionEnabled = false
      cell.textField.delegate = self
      cell.setUp(lesson: viewModel.lesson, indexPath: indexPath)
      
      return cell
    }
  }


  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if let _ = tableView.cellForRow(at: indexPath) as? AddRowTableViewCell {
      return false
    } else {
      return true
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
