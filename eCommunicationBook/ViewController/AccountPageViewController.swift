//
//  AccountViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class AccountPageViewController: UIViewControllerWithImagePicker {

  @IBOutlet weak var labelUserName: UILabel!
  
  @IBOutlet weak var labelUserType: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var imageViewAccountIcon: UIImageView!
  
  let viewModel = AccountPageViewModel()
    
  override func viewDidLoad() {
    
    super.viewDidLoad()

    tableView.registerCellWithNib(identifier: AccountItemTableViewCell.identifier, bundle: nil)

    imagePicker.delegate = self

    viewModel.onImageUploaded = {
      self.loadIconImage()
    }
    loadViewContent()
    loadIconImage()
  }
  
  func loadViewContent() {
    var name = "User"
    
    if UserManager.shared.user.name != "" {
      name = UserManager.shared.user.name
    }
    labelUserName.text = name
    labelUserType.text = UserManager.shared.user.userType
  }
  
  func loadIconImage() {
    imageViewAccountIcon.loadImage(UserManager.shared.user.image, placeHolder: UIImage(systemName: "person.crop.circle"))
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "accountEditContent",
      let accountEditContentViewController = segue.destination as? AccountEditContentViewController {
      accountEditContentViewController.delegate = self
      if let indexPath = sender as? IndexPath {
        accountEditContentViewController.viewModel.editContentPageTitle = viewModel.accountPageItem()[indexPath.section][indexPath.row]
        accountEditContentViewController.viewModel.textFieldTag = indexPath.section * 10 + indexPath.row
      }
    }
  }
}

extension AccountPageViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.accountPageItem().count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.accountPageItem()[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountItemTableViewCell.identifier,
                                                   for: indexPath) as? AccountItemTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    cell.setUp(viewModel: viewModel.accountPageItem(), indexPath: indexPath)
    return cell
  }
  
}

extension AccountPageViewController: UpdateViewDelegate {
  func onUpdateView() {
    loadViewContent()
    tableView.reloadData()
  }
}

extension AccountPageViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .lightGray
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12
  }
  
  //  func setUptableview() {
  //    self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
  //  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    switch viewModel.accountPageItem()[indexPath.section][indexPath.row]{
    case "Set profile icon":
      showUploadMenu()
    default:
      performSegue(withIdentifier: "accountEditContent", sender: indexPath)
    }
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  private func showNewAThingViewController() {
    
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



extension AccountPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      viewModel.uploadImage(with: image)
    }
    dismiss(animated: true, completion: nil)
  }
}

