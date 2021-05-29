//
//  LessonPerformancesViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class LessonPerformancesViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel = LessonPerformancesViewModel()
  
  var hotCellHeight: CGFloat = UIScreen.height / 1.1

  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 0.0,
    left: 0.0,
    bottom: 0.0,
    right: 0.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.registerCellWithNib(identifier: LPMainCollectionViewCell.identifier, bundle: nil)
    collectionView.isPagingEnabled = true
    
    viewModel.setViewModel()
    
    viewModel.studentLessonRecordsViewModel.bind { [weak self] _ in
      self?.collectionView.reloadData()
    }
    
    viewModel.onSaved = { [weak self] () in
      self?.dismiss(animated: true, completion: nil)
    }
    
     setCollectionViewStack()
  }
  
  @IBAction func saveButtonPressed(_ sender: Any) {
    viewModel.onSave()
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
    popViewController()
  }

  func popViewController() {
        guard let nav = navigationController, nav.topViewController != nil else {
            return
        }
        nav.popViewController(animated: true)
  }
  
    @objc func sliderValueChanged(sender: UISlider) {
  //      let buttonTag = sender.tag
      print(sender.tag)
//      performSegue(withIdentifier: "lessonPlanDetail", sender: sender)
      sender.value.round()
//      numberLabel.text = Int(sender.value).description
      viewModel.onPerformanceSliderSlides(index: sender.tag, value: Int(sender.value))
    }
  
      @objc func buttonStatusChanged(sender: UIButton) {
        if !(sender.isSelected) {
           sender.isSelected = true
          viewModel.onAssignmentsStatusToggle(index: sender.tag)
        } else {
            sender.isSelected = false
            viewModel.onAssignmentsStatusToggle(index: sender.tag)
        }
      }
  
  func setCollectionViewStack() {
    let verticalSnapCollectionFlowLayout = StackCollectionViewLayout()
    collectionView.collectionViewLayout = verticalSnapCollectionFlowLayout
    collectionView.setCollectionViewLayout(verticalSnapCollectionFlowLayout, animated: true)

  }
}

extension LessonPerformancesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.studentLessonRecordsViewModel.value.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPMainCollectionViewCell.identifier,
                                                        for: indexPath) as? LPMainCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    print(indexPath.item)
    cell.setUp(viewModel: self.viewModel.studentLessonRecordsViewModel.value[indexPath.item], indexPath: indexPath)
    cell.tableView.tag = indexPath.item
    cell.tableView.reloadData()
    cell.tableView.dataSource = self
    cell.tableView.delegate = self
    return cell
  }
}

extension LessonPerformancesViewController: UICollectionViewDelegate {
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if let _ = scrollView as? UICollectionView {

    var cellsIndex: [Int] = []
    for cell in collectionView.visibleCells {
      if let indexPath = collectionView.indexPath(for: cell) {
      cellsIndex.append(indexPath.item)
        print(indexPath)
    }
    }
    guard let cellIndexMin = cellsIndex.min() else { return }
    print(cellIndexMin)
    viewModel.onMainCollectionViewScrolled(destination: cellIndexMin)
    } else {
      viewModel.onMainCollectionViewInnerScrolled()
    }
  }
}

extension LessonPerformancesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.sectionTitles[section]
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.sectionTitles.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch viewModel.sectionTitles[section] {
    case "Lesson Performances":
      return viewModel.performancesItem.count
    case "Homework Status":
      return viewModel.previousLesson.assignments!.count
    case "Tests Grade":
      return viewModel.previousLesson.tests!.count
    case "Comunication Corner":
      return 1
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let section = tableView.tag
    
    switch viewModel.sectionTitles[indexPath.section] {
      
    case "Lesson Performances":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPSlideTableViewCell.identifier,
                                                     for: indexPath) as? LPSlideTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(viewModel: self.viewModel.studentLessonRecordsViewModel.value[section], indexPath: indexPath)
      cell.slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .touchUpInside)
      cell.slider.tag = indexPath.row
      return cell
    case "Homework Status":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPHomeWorkTableViewCell.identifier,
                                                     for: indexPath) as? LPHomeWorkTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(viewModel: self.viewModel.studentLessonRecordsViewModel.value[section], indexPath: indexPath)
      
      cell.checkButton.addTarget(self, action: #selector(buttonStatusChanged(sender:)), for: .touchUpInside)
      cell.checkButton.tag = indexPath.row
      return cell
      
    case "Tests Grade":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPTestScoreTableViewCell.identifier,
                                                     for: indexPath) as? LPTestScoreTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textFieldScore.tag = indexPath.row
      cell.textFieldScore.delegate = self
      cell.setUp(viewModel: self.viewModel.studentLessonRecordsViewModel.value[section], indexPath: indexPath)

      return cell
    case "Comunication Corner":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPCommunicationCornerTableViewCell.identifier,
                                                     for: indexPath) as? LPCommunicationCornerTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textViewCommunicationCorner.delegate = self
      cell.setUp(viewModel: self.viewModel.studentLessonRecordsViewModel.value[section])
      return cell
      
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPTestScoreTableViewCell.identifier,
                                                     for: indexPath) as? LPTestScoreTableViewCell
        else { fatalError("Unexpected Table View Cell") }

      return cell
      
    }
  }
}

extension LessonPerformancesViewController: UITableViewDelegate {
  
}

extension LessonPerformancesViewController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    guard let content = textView.text else {
      return
    }
    viewModel.onCommunicationCorneChanged(text: content)
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "type message..."
      textView.textColor = .lightGray
    }
  }
}

extension LessonPerformancesViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let info = textField.text else { return }
    viewModel.onChangeContent(index: textField.tag, text: info)
  }
}
