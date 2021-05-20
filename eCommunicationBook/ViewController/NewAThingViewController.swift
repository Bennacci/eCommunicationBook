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
  
  var inputTexts: [[String]] = [["Name", "User Type"], ["Birth Date", "National ID"], ["E-mail", "CellPhone Number", "Contact Number"], ["image"]]
  var pickerIndexPath: IndexPath?
  var selectedIndexPath: IndexPath?
  var inputDates: [[Date]] = []
  var inputValuse: [[Any]] = []
  
  var tempUserType: UserType? = nil
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    tableView.registerCellWithNib(identifier: TextFieldTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: TwoLablesTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: DatePickerTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: PickerViewTableViewCell.identifier, bundle: nil)
    addInitailValues()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func pop(_ sender: Any) {
    print("hi")
    self.navigationController?.popViewController(animated: true)
    
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
    
    if pickerIndexPath == indexPath && inputTexts[indexPath.section][indexPath.row - 1] == "Birth Date"{
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier,
                                                     for: indexPath) as? DatePickerTableViewCell
        
        else { fatalError("Unexpected Table View Cell") }
      
      cell.updateCell(date: inputDates[indexPath.section][indexPath.row - 1], indexPath: indexPath)
      
      cell.delegate = self
      
      return cell
      
    } else if pickerIndexPath == indexPath {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PickerViewTableViewCell.identifier,
                                                     for: indexPath) as? PickerViewTableViewCell
        
        else { fatalError("Unexpected Table View Cell") }
      //    cell.updateCell(date: inputDates[indexPath.section][indexPath.row - 1], indexPath: indexPath)
      cell.updateCell(indexPath: indexPath)
      
      cell.pickerView.delegate = self
      
      return cell
      
    } else if inputTexts[indexPath.section][indexPath.row] == "Birth Date" ||
      
      inputTexts[indexPath.section][indexPath.row] == "User Type" {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoLablesTableViewCell.identifier,
                                                     for: indexPath) as? TwoLablesTableViewCell
        
        else { fatalError("Unexpected Table View Cell") }
      
      switch inputTexts[indexPath.section][indexPath.row] {
        
      case "Birth Date":
        
        cell.updateText(text: inputTexts[indexPath.section][indexPath.row],
                        
                        date: inputDates[indexPath.section][indexPath.row])
        return cell
      default:
        cell.updateText(text: inputTexts[indexPath.section][indexPath.row],
                        type: tempUserType?.rawValue ?? "type")
        return cell
      }
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier,
                                                     for: indexPath) as? TextFieldTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.textField.placeholder = "點擊輸入"
      cell.title.text = inputTexts[indexPath.section][indexPath.row]
      cell.textField.delegate = self
      
      switch inputTexts[indexPath.section][indexPath.row] {
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    guard let info = textField.text else { return }
    switch selectedIndexPath {
    case <#pattern#>:
      

    default:
      <#code#>
    }
    
  }
}

extension NewAThingViewController: PickerDelegate {
  func didChangeData(type: UserType, indexPath: IndexPath) {
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  func didChangeDate(date: Date, indexPath: IndexPath) {
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
    
    guard let twoLablescell = tableView.cellForRow(at: [pickerIndexPath!.section, pickerIndexPath!.row-1]) as? TwoLablesTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    twoLablescell.secondLabel.text = tempUserType?.rawValue
  }
}
