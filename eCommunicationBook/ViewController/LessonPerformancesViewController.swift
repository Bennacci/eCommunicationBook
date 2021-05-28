//
//  LessonPerformancesViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class LessonPerformancesViewController: UIViewController{
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
  
  
}

extension LessonPerformancesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.studentLessonRecordsViewModel.value.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPMainCollectionViewCell.identifier,
                                                        for: indexPath) as? LPMainCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    cell.setUp(viewModel: self.viewModel, indexPath: indexPath)
    cell.tableView.dataSource = self
    cell.tableView.delegate = self
    
    return cell
  }
  
  
}

extension LessonPerformancesViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////    guard let cell = collectionView.cellForItem(at: IndexPath(item: viewModel.performancesItem.count - 1, section: 0)) as? LPMainCollectionViewCell else { return }
//      for cell in collectionView.visibleCells {
//          let indexPath = collectionView.indexPath(for: cell)
//          print(indexPath)
//      }
    let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
    guard let desItem = visibleIndexPath?.item else { return }
    viewModel.onMainCollectionViewScrolled(destination: desItem)
  }

}

extension LessonPerformancesViewController: UICollectionViewDelegateFlowLayout {
  ///  Collection View distance to Super View
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return collectionViewSectionInsets
  }
  
  /// CollectionViewCell  height / width
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    var size: CGSize
    size = collectionView.calculateCellsize(viewHeight: hotCellHeight,
                                            viewWidth: UIScreen.width,
                                            sectionInsets: collectionViewSectionInsets,
                                            itemsPerRow: 1,
                                            itemsPerColumn: 1)
    return size
  }
  
  /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
    
  }
  
}

extension LessonPerformancesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.sectionTitles[section]
    //    switch section {
//    case 0:
//      return "Lesson Performances"
//    case 1:
//      return "Homework status"
//    case 2:
//      return "Tests status"
//    default:
//      return "Communication Corner"
//    }
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
    switch viewModel.sectionTitles[indexPath.section] {
      
    case "Lesson Performances":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPSlideTableViewCell.identifier,
                                                     for: indexPath) as? LPSlideTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(viewModel: self.viewModel, indexPath: indexPath)
      cell.slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .touchUpInside)
      cell.slider.tag = indexPath.row
      return cell
    case "Homework Status":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPHomeWorkTableViewCell.identifier,
                                                     for: indexPath) as? LPHomeWorkTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(viewModel: self.viewModel, indexPath: indexPath)
      
      cell.checkButton.addTarget(self, action: #selector(buttonStatusChanged(sender:)), for: .touchUpInside)
      cell.checkButton.tag = indexPath.row
      return cell
      
    case "Tests Grade":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPTestScoreTableViewCell.identifier,
                                                     for: indexPath) as? LPTestScoreTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textFieldScore.tag = indexPath.row
      cell.textFieldScore.delegate = self
      cell.setUp(viewModel: self.viewModel, indexPath: indexPath)

      return cell
    case "Comunication Corner":
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LPCommunicationCornerTableViewCell.identifier,
                                                     for: indexPath) as? LPCommunicationCornerTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textViewCommunicationCorner.delegate = self
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
