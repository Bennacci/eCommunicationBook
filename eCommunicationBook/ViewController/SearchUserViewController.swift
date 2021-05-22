//
//  SearchUserViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

protocol SearchUserDelegate {
  func onSearchAndSelected()
}

class SearchUserViewController: UIViewController {

  
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var searchTableView: UITableView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var cancleButtonWidth: NSLayoutConstraint!
  
  var delegate: SearchUserDelegate?
  
  var selectedCellHeight: CGFloat = 100
  
  var wideUserCellHeight: CGFloat = 50
  
  let viewModel = SearchUserPageViewModel()
  
//  let newAThingViewModel = NewAThingViewModel()
  
  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 4.0,
    left: 16.0,
    bottom: 4.0,
    right: 16.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    searchBar.showsScopeBar = true
    // Do any additional setup after loading the view.
//    newAThingViewModel.searchUserDelegate = self
//    self.navigationController?.setNavigationBarHidden(false, animated: true)

    tableView.registerCellWithNib(identifier: WideUserTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: SelecetedUserTableViewCell.identifier, bundle: nil)
    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    viewModel.userViewModel.bind { [weak self] users in
      //            self?.tableView.reloadData()
      self?.viewModel.onRefresh()
    }
    viewModel.userListViewModel.bind { [weak self] users in
                  self?.tableView.reloadData()
      
      self?.viewModel.onRefresh()
    }
    
    viewModel.fetchData()
  }
  @IBAction func popViewController(_ sender: Any) {
    dismiss(animated: true, completion: nil)

    
  }
  
  @IBAction func sendAndQuitViewController(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    
    viewModel.onSendAndQuit()

    
    
    delegate?.onSearchAndSelected()
//    self.onSearchAndSelected()
    
  }
  
  
  @IBAction func cancleSearching(_ sender: Any) {
    if let viewWithTag = self.view.viewWithTag(100) {
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
        
        viewWithTag.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.cancleButtonWidth.constant = 0
      },
                                                     completion: nil)
      viewWithTag.removeFromSuperview()
    } else {
      print("No!")
    }
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    searchBar.endEditing(true)
  }
  
  
  
}

extension SearchUserViewController: UISearchBarDelegate {
  
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    let blackView = UIView()
    blackView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: UIScreen.height)
    blackView.backgroundColor = UIColor(white: 0, alpha: 0)
    blackView.tag = 100
    tableView.addSubview(blackView)
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
      
      blackView.backgroundColor = UIColor(white: 0, alpha: 0.8)
      self.cancleButtonWidth.constant = 75
    },
                                                   completion: nil)
  }
//  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//    <#code#>
//  }
  func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
    //    viewModel.fetchData()
    if searchBar.text != ""{
      searchTableView.isHidden = false
    } else {
      searchTableView.isHidden = true
    }
  }
}

extension SearchUserViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    if tableView == self.tableView {
      if viewModel.userListViewModel.value.count == 0 {
        return 1
      } else {
        return 2
      }
    } else {
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if tableView == self.tableView {
      if viewModel.userListViewModel.value.count != 0 {
        switch section {
        case 0:
          return ""
        default:
          return "推薦"
        }
      } else {
        return "推薦"
      }
    } else {
      return "搜尋結果"
    }
    
  }
  
  func tableView(_ tableView: UITableView,
                 
                 numberOfRowsInSection section: Int) -> Int {
    
    if viewModel.userListViewModel.value.count == 0 || tableView == searchTableView {
      return viewModel.userViewModel.value.count
    } else {
      return [1, viewModel.userViewModel.value.count][section]
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath == [0, 0] && viewModel.userListViewModel.value.count != 0 && tableView == self.tableView {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SelecetedUserTableViewCell.identifier,
                                                     for: indexPath) as? SelecetedUserTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.collectionView.delegate = self
      
      cell.collectionView.dataSource = self
      
      cell.collectionView.reloadData()
      
      cell.height.constant = selectedCellHeight
      
      return cell
      
    } else {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: WideUserTableViewCell.identifier,
                                                     for: indexPath) as? WideUserTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      let cellViewModel = self.viewModel.userViewModel.value[indexPath.row]
      
      cell.height.constant = wideUserCellHeight
      
      cell.setup(list: viewModel.userListViewModel, viewModel: cellViewModel)
            
      return cell
    }
  }
}

extension SearchUserViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? WideUserTableViewCell else {return}
    if cell.circleIcon.isHidden == true {

      viewModel.removeUserFromList(user: viewModel.userViewModel.value[indexPath.row])
    } else {
      
      viewModel.addUserToList(user: viewModel.userViewModel.value[indexPath.row])
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
  
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
////    if section == 0 {
////
////      return CGFloat.leastNormalMagnitude
////
////    } else {
////
////      return 35
////    }
//  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return CGFloat.leastNormalMagnitude
  }
}

extension SearchUserViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return self.viewModel.userListViewModel.value.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleUserCollectionViewCell.identifier,
                                                        for: indexPath) as? CircleUserCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    
	    let cellViewModel = self.viewModel.userListViewModel.value[indexPath.item]
    
//    cell.height.constant = wideUserCellHeight
    
    cell.setup(viewModel: cellViewModel)
    
    cell.layoutCell()
    
    return cell
  }
}

extension SearchUserViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    guard let cell = collectionView.cellForItem(at: indexPath) as? CircleUserCollectionViewCell else {return}
    viewModel.removeUserFromList(user: viewModel.userListViewModel.value[indexPath.item])

  }
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
