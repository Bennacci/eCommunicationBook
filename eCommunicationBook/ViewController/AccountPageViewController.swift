//
//  AccountViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class AccountPageViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let viewModel = ServiceViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUptableview()
  }
}

extension AccountPageViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.services.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.services[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell",
                                                   for: indexPath) as? ServiceTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    cell.layoutCell(title: viewModel.services[indexPath.section][indexPath.row])
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
}
