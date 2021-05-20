//
//  AccountViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class AccountPageViewController: UIViewController{
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func toggleUser(_ sender: UISwitch) {

    if sender.isOn {

      UserManager.shared.userType = .teacher

      tableView.reloadData()

    } else {

      UserManager.shared.userType = .parents

      tableView.reloadData()
    }
  }
  
  let viewModel = AccountPageViewModel()
  
  override func viewDidLoad() {

    super.viewDidLoad()

    setUptableview()

    self.navigationController?.setNavigationBarHidden(true, animated: true)

  }
  
  override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

  }

}

extension AccountPageViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.servicesData().items.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.servicesData().items[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier,
                                                   for: indexPath) as? ServiceTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    cell.layoutCell(accountItem: viewModel.servicesData().items[indexPath.section][indexPath.row])
    return cell
  }

}

extension AccountPageViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12
  }
  
  func setUptableview() {
    self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let nextVC = UIStoryboard.newAThing.instantiateInitialViewController() {
      nextVC.modalPresentationStyle = .fullScreen
//      show(nextVC, sender: nil)
//      present(nextVC, animated: false, completion: nil)
      self.navigationController?.show(nextVC, sender: nil)
    } 
  }
  
  func isTokenExist() -> Bool {
      guard UserManager.shared.isLogin() != false else {
          
//          if let nextVC = UIStoryboard.auth.instantiateInitialViewController() {
//
//              nextVC.modalPresentationStyle = .overCurrentContext
//
//              present(nextVC, animated: false, completion: nil)
//          }
          
          return false
      }
      
      return true
  }
}
