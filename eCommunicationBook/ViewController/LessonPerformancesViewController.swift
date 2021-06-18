//
//  LessonPerformancesViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class LessonPerformancesViewController: UIViewControllerWithImagePicker {
  
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
    
    imagePicker.delegate = self
    
    collectionView.registerCellWithNib(identifier: LPMainCollectionViewCell.identifier, bundle: nil)
    collectionView.isPagingEnabled = true
    
    viewModel.setViewModel()
    
    viewModel.studentLessonRecordsViewModel.bind { [weak self] _ in
    
        self?.collectionView.reloadData()
    }
    
    viewModel.refreshView = {[weak self] () in
      
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
    
    sender.isSelected = !sender.isSelected
    
    viewModel.onAssignmentsStatusToggle(index: sender.tag)
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
    cell.setUp(viewModel: self.viewModel.studentLessonRecordsViewModel.value[indexPath.item])
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
    case "Upload Image":
      if let count = viewModel.studentLessonRecord.images?.count {
        return count + 1
      } else {
        return 1
      }
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let section = tableView.tag
    
    let studenLessonRecordViewModel = self.viewModel.studentLessonRecordsViewModel.value[section]
    
    switch viewModel.sectionTitles[indexPath.section] {
      
    case "Lesson Performances":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPSliderTableViewCell.identifier,
                                                     for: indexPath) as? LPSliderTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(viewModel: studenLessonRecordViewModel, indexPath: indexPath)
      cell.slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .touchUpInside)
      cell.slider.tag = indexPath.row
      return cell
    case "Homework Status":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPHomeWorkTableViewCell.identifier,
                                                     for: indexPath) as? LPHomeWorkTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(viewModel: studenLessonRecordViewModel, indexPath: indexPath)
      
      cell.buttonCheckHomework.addTarget(self, action: #selector(buttonStatusChanged(sender:)), for: .touchUpInside)
      cell.buttonCheckHomework.tag = indexPath.row
      return cell
      
    case "Tests Grade":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPTestScoreTableViewCell.identifier,
                                                     for: indexPath) as? LPTestScoreTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textFieldScore.tag = indexPath.row
      cell.textFieldScore.delegate = self
      cell.setUp(viewModel: studenLessonRecordViewModel, indexPath: indexPath)
      
      return cell
    case "Comunication Corner":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPCommunicationCornerTableViewCell.identifier,
                                                     for: indexPath) as? LPCommunicationCornerTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textViewCommunicationCorner.delegate = self
      cell.setUp(viewModel: studenLessonRecordViewModel)
      return cell
      
    case "Upload Image":
      
      if let count = viewModel.studentLessonRecord.images?.count, count != indexPath.row {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UploadImageTableViewCell.identifier,
                                                       for: indexPath) as? UploadImageTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.setUp(viewModel: studenLessonRecordViewModel, indexPath: indexPath)
        cell.textFieldImageTitle.tag = indexPath.row * 100
        cell.textFieldImageTitle.delegate = self
        cell.buttonDeleteImage.tag = indexPath.row
        cell.buttonDeleteImage.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        return cell
      } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRowTableViewCell.identifier,
                                                       for: indexPath) as? AddRowTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.prepareForUploadImage()
        return cell
        
      }
      
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPTestScoreTableViewCell.identifier,
                                                     for: indexPath) as? LPTestScoreTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      return cell
      
    }
  }
  @objc func deleteButtonTapped(sender: UIButton) {
    viewModel.onDeleteImage(index: sender.tag)
  }
}

extension LessonPerformancesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let _ = tableView.cellForRow(at: indexPath) as? AddRowTableViewCell {
      showUploadMenu()
    }
  }
}

extension LessonPerformancesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      viewModel.uploadImage(with: image)
    }
    dismiss(animated: true, completion: nil)
  }
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
