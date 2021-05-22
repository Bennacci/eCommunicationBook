//
//  NewAClassViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
//
//class NewAThingManager {
//  static let shared = NewAThingManager()
//
//  var service = "Create User"
//
//  func viewModel() -> NewAThingViewModel{
//    switch service {
//    case  "Create User":
//      return NewAUserViewModel()
//    default:
//      return NewACourseViewModel()
//    }
//  }
//  //  private let target: String
//
//  //  var viewModel: Any {
//  //    switch target {
//  //    case "Create User":
//  //      return NewAUserViewModel()
//  //    default:
//  //      return NewACourseViewModel()
//  //    }
//  //  }
//}

class NewAThingViewController: UIViewController {
  
  let viewModel = NewAThingViewModel()
  
  var pickerMotherIndexPath: IndexPath?
  
  var pickerIndexPath: IndexPath? {
    didSet {
      if pickerIndexPath != nil {
        self.pickerMotherIndexPath = IndexPath(row: pickerIndexPath!.row - 1, section: pickerIndexPath!.section)
      }
    }
  }
  
  var willExpand: Bool = false
  
  weak var delegate: PublishDelegate?
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    tableView.registerCellWithNib(identifier: TextFieldTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: TwoLablesTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: TwoLablesWithButtonTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: DatePickerTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: PickerViewTableViewCell.identifier, bundle: nil)
    // Do any additional setup after loading the view.
    viewModel.loadInitialValues()
    
    viewModel.onDataUpdated = { [weak self] () in
      self?.tableView.reloadData()
    }
    
    viewModel.onAdded = { [weak self] () in
      self?.delegate?.onPublished()
      self?.navigationController?.popViewController(animated: true)
      //        self?.dismiss(animated: true, completion: nil)
    }
  }
    
  
  @IBAction func cancle(_ sender: Any) {
    print("hi")
    self.navigationController?.popViewController(animated: true)
    
  }
  
  @IBAction func send(_ sender: Any) {
    viewModel.onTapAdd()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationNavigationController = segue.destination as? UINavigationController,
      let targetController = destinationNavigationController.topViewController as? SearchUserViewController
      else { fatalError("Unexpected Table View Cell") }
    
    targetController.delegate = self.viewModel
//      if segue.identifier == "navigateToPublish",
//      let publishViewController = segue.destination as? PublishViewController {
//
//      publishViewController.delegate = self
//
//    }
  }
}

extension NewAThingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.inputTexts.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if willExpand == true  && pickerIndexPath?.section == section {
      return viewModel.inputTexts[section].count + 1
    } else {
      return viewModel.inputTexts[section].count
    }
  }
  // swiftlint:disable function_body_length cyclomatic_complexity
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let inputText: String
    let inputDate: Date
    
    if pickerIndexPath == nil || pickerIndexPath != indexPath {
      inputText = viewModel.inputTexts[indexPath.section][indexPath.row]
      inputDate = viewModel.inputDates[indexPath.section][indexPath.row]
    } else {
      inputText = viewModel.inputTexts[indexPath.section][indexPath.row - 1]
      inputDate = viewModel.inputDates[indexPath.section][indexPath.row - 1]
    }
    
    if pickerIndexPath == indexPath {
      
      switch  inputText {
        
      case "Birth Date", "First Lesson Date":
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier,
                                                       for: indexPath) as? DatePickerTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.updateCell(date: inputDate, indexPath: indexPath)
        cell.delegate = self
        return cell
        
      case "User Type":
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PickerViewTableViewCell.identifier,
                                                       for: indexPath) as? PickerViewTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.updateCell(indexPath: indexPath)
        cell.pickerView.delegate = self
        return cell
        
      default:
        //         check bug soon
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier,
                                                       for: indexPath) as? TextFieldTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        //        cell.isHidden = true
        return cell
      }
      
    } else if inputText == "Birth Date" || inputText == "User Type" || inputText == "First Lesson Date" {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoLablesTableViewCell.identifier,
                                                     for: indexPath) as? TwoLablesTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      switch inputText {
      case "User Type":
        cell.updateText(text: inputText,
                        type: viewModel.user.userType)
        return cell
      default:
        cell.updateText(text: inputText,
                        date: inputDate)
        return cell
      }
    } else if inputText == "Teachers" || inputText == "Students"{
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoLablesWithButtonTableViewCell.identifier,
                                                     for: indexPath) as? TwoLablesWithButtonTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.updateText(text: inputText)
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier,
                                                     for: indexPath) as? TextFieldTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textField.placeholder = "點擊輸入"
      
      cell.title.text = inputText
      cell.textField.delegate = self
      switch inputText {
      case "CellPhone Number", "Contact Number":
        cell.textField.keyboardType = .numberPad
//      case "Contact Number":
//        cell.textField.keyboardType = .numberPad
      case "E-mail":
        cell.textField.keyboardType = .emailAddress
      default:
        cell.textField.keyboardType = .default
      }
      return cell
    }
  }
}
  // swiftlint:enable function_body_length cyclomatic_complexity

extension NewAThingViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12
  }
  //  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
  //
  //  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let inputText = viewModel.inputTexts[indexPath.section][indexPath.row]
    
    if inputText == "User Type" || inputText == "Birth Date" || inputText == "First Lesson Date" {
      
      if pickerIndexPath != nil && indexPath != pickerMotherIndexPath {
        
        willExpand = false
        
        tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
        
        pickerIndexPath = indexPathToInsertPicker(indexPath: indexPath)
        
        willExpand = true
        
        tableView.insertRows(at: [pickerIndexPath!], with: .fade)
        
      } else if pickerIndexPath != nil && indexPath == pickerMotherIndexPath {
        
        willExpand = false
        
        tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
        
        pickerIndexPath = nil
        
        self.pickerIndexPath = nil
        
      } else {
        
        willExpand = true
        
        pickerIndexPath = indexPathToInsertPicker(indexPath: indexPath)
        
        tableView.insertRows(at: [pickerIndexPath!], with: .fade)
        
      }
      
    } else {
      
      if pickerIndexPath !=  nil {
        
        willExpand = false
        
        tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
        
        pickerIndexPath = nil
      }
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    if inputText == "Teachers" || inputText == "Students"{
      if let nextVC = UIStoryboard.searchUser.instantiateInitialViewController() {

          guard let targetController = nextVC.children[0] as? SearchUserViewController
            
          else { fatalError("Unexpected Table View Cell") }
        
          targetController.delegate = self.viewModel
        if inputText == "Students"{
          targetController.viewModel.secondTime = true
        }
        self.navigationController?.show(nextVC, sender: nil)
        
      } else { return }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath == pickerIndexPath && willExpand == true {
      return DatePickerTableViewCell.cellHeight()
    } else {
      return TwoLablesTableViewCell.cellHeight()
    }
  }
  
  func indexPathToInsertPicker(indexPath: IndexPath) -> IndexPath {
    
    return IndexPath(row: indexPath.row + 1, section: indexPath.section)
    
  }
}

extension NewAThingViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    //    tableView.beginUpdates()
    
    if pickerIndexPath !=  nil {
      
      willExpand = false
      
      tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
      
      pickerIndexPath = nil
    }
    
    //    tableView.endUpdates()
    //        updateViewModel(with: textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateViewModel(with: textField)
  }
  
  func updateViewModel(with textField: UITextField) {
    let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
    guard let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable) else {return}
    guard let info = textField.text else { return }
    switch viewModel.inputTexts[textFieldIndexPath.section][textFieldIndexPath.row] {
    case "Name":
      viewModel.onNameChanged(text: info)
    case "ID":
      viewModel.onUserIDChanged(text: info)
    case "E-mail":
      viewModel.onEmailChanged(text: info)
    case "CellPhone Number":
      viewModel.onCellPhoneNoChanged(text: info)
    case "Contact Number":
      viewModel.onHomePhoneNoChanged(text: info)
    case "Class Name":
      viewModel.onCourseNameChanged(text: info)
    case "Fee":
      viewModel.onFeeChanged(text: info)
    default:
      return
    }
  }
}

extension NewAThingViewController: PickerDelegate {
  func didChangeData(type: UserType, indexPath: IndexPath) {
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  func didChangeDate(date: Date, indexPath: IndexPath) {
    viewModel.onBirthDayChanged(day: date)
    viewModel.inputDates[indexPath.section][indexPath.row] = date
    tableView.reloadRows(at: [indexPath], with: .none)
  }
}
  

extension NewAThingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return UserType.allCases.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return UserType.allCases[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    viewModel.onUserTypeChanged(text: UserType.allCases[row].rawValue)
  }
}

protocol PublishDelegate: AnyObject {
  func onPublished()
}
