//
//  StudentTimeInAndOutViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/3.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class StudentTimeInAndOutViewController: UIViewController {
  
  var viewModel = StudentTimeInAndOutViewModel()
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var buttonExpand: UIButton!
  
  @IBOutlet weak var heightConMenu: NSLayoutConstraint!
  
  @IBOutlet weak var blackView: UIView!
  
  var menuExpanded = false
  
  var selectedCellHeight: CGFloat = 100
  
  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 4.0,
    left: 16.0,
    bottom: 4.0,
    right: 16.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerCellWithNib(identifier: StudentExistancesTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: StudentTimeInTimeOutTableViewCell.identifier, bundle: nil)
    viewModel.fetchExistances(studentIndex: nil, date: nil)
    
    collectionView.registerCellWithNib(identifier: CircleUserCollectionViewCell.identifier, bundle: nil)
    
    viewModel.existancesFetched = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
        self?.viewModel.refreshCellDateDic()
      }
    }
    
    viewModel.setStudentViewModel()
  }
  
  @IBAction func tapBackButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    
  }
  
  @IBAction func tapButtonExpand(_ sender: Any) {
    
    if menuExpanded == false {
      expandMenu()
    } else {
      collapseMenu()
    }
  }
  
  func expandMenu() {
    blackView.isHidden = false
    
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
      self.blackView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
      self.heightConMenu.constant = 320
      self.buttonExpand.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      
    }, completion: nil)
    
    menuExpanded = true
  }
  
  func collapseMenu() {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
      self.blackView.backgroundColor = UIColor.gray.withAlphaComponent(0.0)
      
      self.heightConMenu.constant = 40
      self.buttonExpand.transform = CGAffineTransform(rotationAngle: 0)
    }, completion: { (_) -> Void in
      self.blackView.isHidden = true
    })
    menuExpanded = false
  }
  
  @IBAction func changeDate(_ sender: UIDatePicker) {
    viewModel.fetchExistances(studentIndex: nil, date: sender.date)
    
    guard let row = viewModel.cellDateDic[sender.date.convertToString(dateformat: .day)] else { return }
    
    let indexPath = IndexPath(row: row, section: 0)
    
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
}

extension StudentTimeInAndOutViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return viewModel.studentTimeInViemModel.value.count
    
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    let myLabel = UILabel()
    myLabel.frame = CGRect(x: 16, y: headerView.frame.height / 4, width: tableView.bounds.size.width, height: 30)
    myLabel.font = UIFont.boldSystemFont(ofSize: 22)
    myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerView.addSubview(myLabel)
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.selectedDate.convertToString(dateformat: .month)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var timeOutViewModel: StudentExistanceViewModel?
    
    // assume every students time out every day
    
    if indexPath.row !=  viewModel.studentTimeOutViemModel.value.count {
      
      timeOutViewModel = viewModel.studentTimeOutViemModel.value[indexPath.row]
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentTimeInTimeOutTableViewCell.identifier,
                                                     for: indexPath) as? StudentTimeInTimeOutTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.setUp(timeInViewModel: viewModel.studentTimeInViemModel.value[indexPath.row],
                 timeOutViewModel: timeOutViewModel)
      return cell
      
    } else {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentExistancesTableViewCell.identifier,
                                                     for: indexPath) as? StudentExistancesTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.setUp(forCalendar: false,
                 timeInViewModel: viewModel.studentTimeInViemModel.value[indexPath.row],
                 timeOutViewModel: timeOutViewModel)
      return cell
      
    }
  }
}

extension StudentTimeInAndOutViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  //
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    //    if indexPath == pickerIndexPath && willExpand == true {
  //    return LableWithVerticalLineTableViewCell.cellHeight()
  //    //    } else {
  //    //      return TwoLablesTableViewCell.cellHeight()
  //    //    }  //  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
}

extension StudentTimeInAndOutViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let count = UserManager.shared.user.student?.count {
      return count
    } else {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleUserCollectionViewCell.identifier,
                                                        for: indexPath) as? CircleUserCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    if viewModel.studentViewModel.value.count == 0 {
      return cell
    }
    let cellViewModel = viewModel.studentViewModel.value[indexPath.item]
    cell.tag = indexPath.item
    var checked = false
    if viewModel.selectedStudent == indexPath.item {
      checked = true
    }
    
    cell.setUpStudent(viewModel: cellViewModel, checked: checked)
    
    //    cell.height.constant = wideUserCellHeight
    return cell
  }
}

extension StudentTimeInAndOutViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    viewModel.fetchExistances(studentIndex: indexPath.item, date: nil)
  }
}
// MARK: - 設定 CollectionView Cell 與 Cell 之間的間距、距確 Super View 的距離等等
extension StudentTimeInAndOutViewController: UICollectionViewDelegateFlowLayout {
  
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
    let size: CGSize
    
    size = collectionView.calculateCellsize(viewHeight: selectedCellHeight,
                                            sectionInsets: collectionViewSectionInsets,
                                            itemsPerRow: 4,
                                            itemsPerColumn: 1)
    
    return size
  }
}
