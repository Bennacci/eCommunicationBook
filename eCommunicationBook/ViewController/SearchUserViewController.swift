//
//  SearchUserViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var selectedCellHeight: CGFloat = 100
  
  var wideUserCellHeight: CGFloat = 50
  
  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 4.0,
    left: 16.0,
    bottom: 4.0,
    right: 16.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tableView.registerCellWithNib(identifier: WideUserTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: SelecetedUserTableViewCell.identifier, bundle: nil)
  }
}

extension SearchUserViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return ""
    default:
      return "推薦"
    }
  }
  
  func tableView(_ tableView: UITableView,
                 
                 numberOfRowsInSection section: Int) -> Int {
    
    return [1, 5][section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath == [0, 0] {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SelecetedUserTableViewCell.identifier,
                                                     for: indexPath) as? SelecetedUserTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.collectionView.delegate = self
      
      cell.collectionView.dataSource = self
      
      cell.height.constant = selectedCellHeight
      
      return cell
      
    } else {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: WideUserTableViewCell.identifier,
                                                     for: indexPath) as? WideUserTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.height.constant = wideUserCellHeight
      
      cell.layoutCell()
      
      return cell
    }
  }
}

extension SearchUserViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? WideUserTableViewCell else {return}
    if cell.unCheckIcon.isHidden == true {
      cell.unCheckIcon.isHidden = false
      cell.checkIcon.isHidden = true
    } else {
      cell.unCheckIcon.isHidden = true
      cell.checkIcon.isHidden = false
    }
  }
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    headerView.backgroundColor = UIColor.clear
    let myLabel = UILabel()
    myLabel.frame = CGRect(x: 16, y: headerView.frame.height / 3,
                           width: tableView.bounds.size.width, height: 30)
    myLabel.font = UIFont.boldSystemFont(ofSize: 18)
    myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerView.addSubview(myLabel)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if section == 0 {
      
      return CGFloat.leastNormalMagnitude
      
    } else {
      
      return 35
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return CGFloat.leastNormalMagnitude
  }
}

extension SearchUserViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleUserCollectionViewCell.identifier,
                                                        for: indexPath) as? CircleUserCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    cell.layoutCell()
    
    return cell
  }
}

extension SearchUserViewController: UICollectionViewDelegate {
  
}
// MARK: - 設定 CollectionView Cell 與 Cell 之間的間距、距確 Super View 的距離等等
extension SearchUserViewController: UICollectionViewDelegateFlowLayout {
  
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
