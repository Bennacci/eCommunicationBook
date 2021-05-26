//
//  TCommunicationBookViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TCommunicationBookViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var hotCellHeight: CGFloat = UIScreen.height / 5
  //
  //  var recommendedCellHeight: CGFloat = UIScreen.height / 5
  //
  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 0.0,
    left: 0.0,
    bottom: 0.0,
    right: 0.0)
  
  var pickedCourseIndexPath: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerCellWithNib(identifier: CourseTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: LessonsTableViewCell.identifier, bundle: nil)
  }
  
  @IBAction func popViewController(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    
    
  }
  
  @IBAction func sendAndQuitViewController(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    
    //    viewModel.onSendAndQuit()
    
    //    delegate?.onSearchAndSelected(forStudent: viewModel.forStudent)
    //    self.onSearchAndSelected()
    
  }
  
}


extension TCommunicationBookViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Hello"
    case 1:
      return "熱門"
    case 2:
      return "為您推薦"
    default:
      return "News"
    }
  }
  
  func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
    
    if pickedCourseIndexPath != nil {
      return 4 + 1
    } else {
      return 4
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath == pickedCourseIndexPath {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonsTableViewCell.identifier,
                                                     for: indexPath) as? LessonsTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.collectionView.dataSource = self
      cell.collectionView.delegate = self
      cell.collectionView.isPagingEnabled = true
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.identifier,
                                                     for: indexPath) as? CourseTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      //      bannerCell = cell
      //
      //      cell.setBannerView()
      //
      //      cell.bannerView.scrollView.delegate = self
      //
      return cell
    }
  }
}

extension TCommunicationBookViewController: UITableViewDelegate {
  
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //
  //    return 220.0;//Choose your custom row height
  //  }
  //
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.beginUpdates()
    if let pickedCourseIndexPath = pickedCourseIndexPath, pickedCourseIndexPath.row - 1 == indexPath.row {
      tableView.deleteRows(at: [pickedCourseIndexPath], with: .fade)
      self.pickedCourseIndexPath = nil
    } else {
      if let pickedCourseIndexPath = pickedCourseIndexPath {
        tableView.deleteRows(at: [pickedCourseIndexPath], with: .fade)
        if indexPath == pickedCourseIndexPath {
          self.pickedCourseIndexPath = nil
        } else {
          self.pickedCourseIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
          tableView.insertRows(at: [self.pickedCourseIndexPath!], with: .fade)
          tableView.deselectRow(at: indexPath, animated: true)
        }
      } else {
      pickedCourseIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
      tableView.insertRows(at: [pickedCourseIndexPath!], with: .fade)
      tableView.deselectRow(at: indexPath, animated: true)
      }
    }
    tableView.endUpdates()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    
    headerView.backgroundColor = UIColor.clear
    let myLabel = UILabel()
    myLabel.frame = CGRect(x: 16, y: headerView.frame.height / 3, width: tableView.bounds.size.width, height: 30)
    myLabel.font = UIFont.boldSystemFont(ofSize: 18)
    myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerView.addSubview(myLabel)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return 35
    
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return CGFloat.leastNormalMagnitude
  }
  
  func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
    if let pickedCourseIndexPath = pickedCourseIndexPath, pickedCourseIndexPath.row < indexPath.row {
      return indexPath
    } else {
      return IndexPath(row: indexPath.row + 1, section: indexPath.section)
    }
  }
  
}

extension TCommunicationBookViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    
    return 15
    
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonCollectionViewCell.identifier,
                                                        for: indexPath) as? LessonCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    //    if collectionView == hotCell.collectionView {
    //      cell.height.constant = hotCell.bounds.size.height
    //    }
    cell.layOutCell(indexPath: indexPath)
    return cell
  }
  
}


extension TCommunicationBookViewController: UICollectionViewDelegate {
  
}


extension TCommunicationBookViewController: UICollectionViewDelegateFlowLayout {
  
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
                                            viewWidth: UIScreen.width - 32.0,
                                            sectionInsets: collectionViewSectionInsets,
                                            itemsPerRow: 1,
                                            itemsPerColumn: 3)
    return size
  }
  
  /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
    
  }
  
  /// 滑動方向為「垂直」的話即「左右」的間距(預設為重直)
  
  //  func collectionView(_ collectionView: UICollectionView,
  //                      layout collectionViewLayout: UICollectionViewLayout,
  //                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
  //    return 8
  //  }
}
