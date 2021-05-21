//
//  NewAClassViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class NewAThingViewController: UIViewController {
  
  let viewModel = NewAThingViewModel()
  
  var inputTexts: [[String]] = [[]]
  
  var pickerIndexPath: IndexPath?
    
  var inputDates: [[Date]] = []
  
  var inputValuse: [[Any]] = []
  
  var tempUserType: UserType?
  
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
    addInitailValues()
    // Do any additional setup after loading the view.
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
  
  func addInitailValues() {
    for index in 0..<inputTexts.count {
      let input = Array(repeating: Date(), count: inputTexts[index].count)
      inputDates.append(input)
      inputValuse.append(input)
    }
  }
}

extension NewAThingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return inputTexts.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if pickerIndexPath != nil && pickerIndexPath?.section == section {
      return inputTexts[section].count + 1
    } else {
      return inputTexts[section].count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let inputText: String
    let inputDate: Date
    if pickerIndexPath == nil {
      inputText = inputTexts[indexPath.section][indexPath.row]
      inputDate = inputDates[indexPath.section][indexPath.row]
    } else {
      inputText = inputTexts[indexPath.section][indexPath.row - 1]
      inputDate = inputDates[indexPath.section][indexPath.row - 1]
    }
    if pickerIndexPath == indexPath {
      switch  inputText {
      case "Birth Date":
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
        // check bug soon
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier,
                                                       for: indexPath) as? TextFieldTableViewCell
          else { fatalError("Unexpected Table View Cell") }
        cell.textField.placeholder = "點擊輸入"
        cell.title.text = inputText
        cell.textField.delegate = self
        return cell
      }
    } else if inputText == "Birth Date" || inputText == "User Type" {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoLablesTableViewCell.identifier,
                                                     for: indexPath) as? TwoLablesTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      switch inputText {
      case "Birth Date":
        cell.updateText(text: inputText,
                        date: inputDate)
        return cell
      default:
        cell.updateText(text: inputText,
                        type: tempUserType?.rawValue ?? "type")
        return cell
      }
    } else if inputText == "Teachers" || inputText == "Students"{
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoLablesWithButtonTableViewCell.identifier,
                                                     for: indexPath) as? TwoLablesWithButtonTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.updateText(text: inputText, numbers: 123)
        return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier,
                                                     for: indexPath) as? TextFieldTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textField.placeholder = "點擊輸入"
      cell.title.text = inputText
      cell.textField.delegate = self
      switch inputText {
      case "CellPhone Number":
        cell.textField.keyboardType = .numberPad
      case "Contact Number":
        cell.textField.keyboardType = .numberPad
      case "E-mail":
        cell.textField.keyboardType = .emailAddress
      default:
        cell.textField.keyboardType = .default
      }
      return cell
    }
  }
}

extension NewAThingViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12
  }
  //  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
  //
  //  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if inputTexts[indexPath.section][indexPath.row] == "Teachers"{
          if let nextVC = UIStoryboard.searchUser.instantiateInitialViewController() {
      //             nextVC.modalPresentationStyle = .fullScreen
      //       //      show(nextVC, sender: nil)
      //             present(nextVC, animated: false, completion: nil)
                   self.navigationController?.show(nextVC, sender: nil)
          } else { return }
    }
    if inputTexts[indexPath.section][indexPath.row] == "User Type" ||
      inputTexts[indexPath.section][indexPath.row] == "Birth Date" {
    tableView.beginUpdates()
    if let datePickerIndexPath = pickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
      tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
      self.pickerIndexPath = nil
    } else {
      if let datePickerIndexPath = pickerIndexPath {
        tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
      }
      pickerIndexPath = indexPathToInsertPicker(indexPath: indexPath)
      tableView.insertRows(at: [pickerIndexPath!], with: .fade)
      tableView.deselectRow(at: indexPath, animated: true)
      view.endEditing(true)
    }
    tableView.endUpdates()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if pickerIndexPath == indexPath {
      return DatePickerTableViewCell.cellHeight()
    } else {
      return TwoLablesTableViewCell.cellHeight()
    }
  }
  
  func indexPathToInsertPicker(indexPath: IndexPath) -> IndexPath {
    if let datePickerIndexPath = pickerIndexPath, datePickerIndexPath.row < indexPath.row {
      return indexPath
    } else {
      return IndexPath(row: indexPath.row + 1, section: indexPath.section)
    }
  }
}

extension NewAThingViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    tableView.beginUpdates()
    if let datePickerIndexPath = pickerIndexPath {
      tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
      self.pickerIndexPath = nil
    }
    tableView.endUpdates()
    //    updateViewModel(with: textField)
    
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateViewModel(with: textField)
  }
  
  func updateViewModel(with textField: UITextField) {
    let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
    guard let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable) else {return}
    guard let info = textField.text else { return }
    switch inputTexts[textFieldIndexPath.section][textFieldIndexPath.row] {
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
    inputDates[indexPath.section][indexPath.row] = date
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
    
    tempUserType = UserType.allCases[row]
    
    guard let twoLablescell = tableView.cellForRow(at: [pickerIndexPath!.section, pickerIndexPath!.row-1])
      as? TwoLablesTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    twoLablescell.secondLabel.text = tempUserType?.rawValue
    viewModel.onUserTypeChanged(text: tempUserType!.rawValue)
  }
}

protocol PublishDelegate: AnyObject {
  func onPublished()
}
