//
//  SearchUserViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

protocol SearchUserDelegate: AnyObject {
    
    func onSearchAndSelected(forStudent: Bool)
}

protocol SearchUserPageMaterial {
    
    var id: String {get}
    var name: String {get}
    var image: String? {get}
}

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    
    weak var delegate: SearchUserDelegate?
    
    var listCount = 0
    
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
        
        tableView.registerCellWithNib(identifier: WideUserTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: SelecetedUserTableViewCell.identifier, bundle: nil)
        
        viewModel.refreshView = { [weak self] () in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
            }
        }
        
        viewModel.userViewModel.bind { [weak self] _ in

            self?.viewModel.onRefresh()
        }
        
        viewModel.userListViewModel.bind { [weak self] _ in
                        
            self?.viewModel.onRefresh()
            
            self?.calculateViewModleListCout()
        }
        
        viewModel.studentViewModel.bind { [weak self] _ in

            self?.viewModel.onRefresh()
        }
        
        viewModel.studentListViewModel.bind { [weak self] _ in
            
            self?.viewModel.onRefresh()
            
            self?.calculateViewModleListCout()
        }
        
        viewModel.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.viewModel.userListViewModel.value.removeAll()
    }
    
    @IBAction func popViewController(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAndQuitViewController(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        viewModel.onSendAndQuit()
        
        delegate?.onSearchAndSelected(forStudent: viewModel.forStudent)
    }
    
    @IBAction func cancelSearching(_ sender: Any) {
        
        if let viewWithTag = self.view.viewWithTag(100) {
       
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
                
                viewWithTag.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
                self.cancelButtonWidth.constant = 0
            },
            
            completion: nil)
            
            viewWithTag.removeFromSuperview()
        
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        searchBar.endEditing(true)
    }
    
    func calculateViewModleListCout() {
        
        if viewModel.forStudent == false {
            
            listCount = viewModel.userListViewModel.value.count
            
        } else {
            
            listCount = viewModel.studentListViewModel.value.count
        }
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
        
            self.cancelButtonWidth.constant = 75
        },
        
        completion: nil)
    }

    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {

        if searchBar.text != String.empty {

            searchTableView.isHidden = false

        } else {

            searchTableView.isHidden = true
        }
    }
}

extension SearchUserViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.tableView {
            
            if listCount == 0 {
                
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
            
            if listCount != 0 {
        
                switch section {
                
                case 0:
                
                    return String.empty
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listCount == 0 || tableView == searchTableView {
            
            if viewModel.forStudent == false {
            
                return viewModel.userViewModel.value.count
            
            } else {
            
                return viewModel.studentViewModel.value.count
            }
            
        } else {
            
            if viewModel.forStudent == false {
            
                return [1, viewModel.userViewModel.value.count][section]
            
            } else {
                
                return [1, viewModel.studentViewModel.value.count][section]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == [0, 0] && listCount != 0 && tableView == self.tableView {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelecetedUserTableViewCell.identifier, for: indexPath) as? SelecetedUserTableViewCell
            
            else {
                
                assertionFailure("SelecetedUserTableViewCell not found")
                
                return UITableViewCell()
            }
            
            cell.collectionView.delegate = self
            
            cell.collectionView.dataSource = self
            
            cell.collectionView.reloadData()
            
            cell.height.constant = selectedCellHeight
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WideUserTableViewCell.identifier, for: indexPath) as? WideUserTableViewCell

            else {
                
                assertionFailure("WideUserTableViewCell not found")
                
                return UITableViewCell()
            }

            if viewModel.forStudent == false {
                
                let cellViewModel = self.viewModel.userViewModel.value[indexPath.row]
                
                cell.setup(list: viewModel.userListViewModel.value, viewModel: cellViewModel)
                
            } else {
                
                let cellViewModel = self.viewModel.studentViewModel.value[indexPath.row]
                
                cell.setup(list: viewModel.studentListViewModel.value, viewModel: cellViewModel)
            }
            
            cell.height.constant = wideUserCellHeight
            
            return cell
        }
    }
}

extension SearchUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? WideUserTableViewCell else {return}
        
        if cell.imageViewCircleIcon.isHidden == true {
            
            viewModel.removeSelectedFromList(index: indexPath.row)

        } else {

            viewModel.addSelectedToList(index: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
}

extension SearchUserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return listCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CircleUserCollectionViewCell.identifier,
                                     for: indexPath) as? CircleUserCollectionViewCell
        
        else {
            
            assertionFailure("CircleUserCollectionViewCell not found")
            
            return UICollectionViewCell()
        }

        var cellViewModel: SearchUserPageMaterial
        
        if viewModel.forStudent == false {
            
            cellViewModel = viewModel.userListViewModel.value[indexPath.item]
        
        } else {
        
            cellViewModel = viewModel.studentListViewModel.value[indexPath.item]
        }
        
        cell.setup(viewModel: cellViewModel)
        
        cell.layoutCell()

        return cell
    }
}

extension SearchUserViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        viewModel.removeSelectedFromList(collectionIndex: indexPath.item)
    }
}

extension SearchUserViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView,

                        layout collectionViewLayout: UICollectionViewLayout,

                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return collectionViewSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size: CGSize
        
        size = collectionView
            .calculateCellsize(viewHeight: selectedCellHeight,
                                                sectionInsets: collectionViewSectionInsets,
                                                itemsPerRow: 4,
                                                itemsPerColumn: 1)
        
        return size
    }
}
