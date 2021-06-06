//
//  LessonPerformancesReviewViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/6.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LessonPerformancesReviewViewController: UIViewControllerWithImagePicker {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel = LessonPerformancesReviewViewModel()
  
  var hotCellHeight: CGFloat = UIScreen.height / 1.1
  
  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 0.0,
    left: 0.0,
    bottom: 0.0,
    right: 0.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    viewModel.fetchData()
    
    viewModel.lessonRecordViewModel.bind { [weak self] _ in
      self?.collectionView.reloadData()
    }
    
    collectionView.registerCellWithNib(identifier: LPMainCollectionViewCell.identifier, bundle: nil)
    
    collectionView.isPagingEnabled = true
    
    setCollectionViewStack()
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
  
  
  func setCollectionViewStack() {
    let verticalSnapCollectionFlowLayout = StackCollectionViewLayout()
    collectionView.collectionViewLayout = verticalSnapCollectionFlowLayout
    collectionView.setCollectionViewLayout(verticalSnapCollectionFlowLayout, animated: true)
    
  }
}

extension LessonPerformancesReviewViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.lessonRecordViewModel.value.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPMainCollectionViewCell.identifier,
                                                        for: indexPath) as? LPMainCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    print(indexPath.item)
    
//    cell.forLessonPlanReview = true
    
    cell.setUp(viewModel: self.viewModel.lessonRecordViewModel.value[indexPath.item])
    
    cell.tableView.tag = indexPath.item

    cell.tableView.reloadData()

    cell.tableView.dataSource = self

    cell.tableView.delegate = self

    return cell
  }
}

extension LessonPerformancesReviewViewController: UICollectionViewDelegate {
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//    if let _ = scrollView as? UICollectionView {
//
//      var cellsIndex: [Int] = []
//      for cell in collectionView.visibleCells {
//        if let indexPath = collectionView.indexPath(for: cell) {
//          cellsIndex.append(indexPath.item)
//          print(indexPath)
//        }
//      }
//      guard let cellIndexMin = cellsIndex.min() else { return }
//      print(cellIndexMin)
//      viewModel.onMainCollectionViewScrolled(destination: cellIndexMin)
//    } else {
//      viewModel.onMainCollectionViewInnerScrolled()
//    }
  }
}

extension LessonPerformancesReviewViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return nil
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return CGFloat.leastNormalMagnitude
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.comunicationSectionTitles[tableView.tag].count

  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let title = viewModel.comunicationSectionTitles[tableView.tag][indexPath.row]
      
      if title == "Lesson Performances"{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier,
                                                       for: indexPath) as? ChartTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.setUp(viewModel: viewModel.lessonRecordViewModel.value[tableView.tag])
        return cell
        
      } else if title == "Student Images" {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentImagesTableViewCell.identifier,
                                                       for: indexPath) as? StudentImagesTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        
        cell.setUp(viewModel: viewModel.lessonRecordViewModel.value[tableView.tag],
                   index: indexPath.row - viewModel.comunicationSectionTitles[tableView.tag].count + 2)
        
        return cell
        
      } else {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodaysLesoonTableViewCell.identifier,
                                                       for: indexPath) as? TodaysLesoonTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.setUp(viewModel: viewModel.lessonRecordViewModel.value[tableView.tag], title: title)
        return cell
      }
    
    
  }

}

extension LessonPerformancesReviewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let _ = tableView.cellForRow(at: indexPath) as? AddRowTableViewCell {
//      showUploadMenu()
    }
  }
}
