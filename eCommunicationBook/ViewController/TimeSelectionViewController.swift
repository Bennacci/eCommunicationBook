//
//  TimeSelectionViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/22.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit


//protocol TimeSelectionDelegate {
//  func didSelectTime()
//}

class TimeSelectionViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = TimeSelectionViewModel()
  
  var willExpand: Bool = false
  
  var pickerMotherIndexPath: IndexPath?
  
  //  var delegate: TimeSelectionDelegate?
  
  var pickerIndexPath: IndexPath? {
    didSet {
      if pickerIndexPath != nil {
        self.pickerMotherIndexPath = IndexPath(row: pickerIndexPath!.row - 1, section: pickerIndexPath!.section)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerCellWithNib(identifier: TwoLablesWithButtonTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: PickerViewTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: TimeIntervalTableViewCell.identifier, bundle: nil)
    
    
    viewModel.onDataUpdated = { [weak self] () in
      self?.tableView.reloadData()
    }
    //    viewModel.delegate = self
  }
}

extension TimeSelectionViewController: UITableViewDataSource {
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
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var spacedIndexPath = indexPath
    
    if pickerIndexPath?.section == indexPath.section {
      if indexPath.row >= pickerIndexPath!.row {
        spacedIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
      }
    }

    let inputText = viewModel.inputTexts[spacedIndexPath.section][spacedIndexPath.row]
    
    if pickerIndexPath == indexPath {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PickerViewTableViewCell.identifier,
                                                     for: indexPath) as? PickerViewTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.pickerView.delegate = self
      cell.pickerView.selectRow(viewModel.routineHouers[indexPath.section].day, inComponent: 0, animated: true)
      return cell
      
    } else if inputText == "Starting Time"{
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeIntervalTableViewCell.identifier,
                                                     for: indexPath) as? TimeIntervalTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.timeSelectionViewModel = viewModel
      
      cell.hourTextField.delegate = self
      
      cell.minuteTextField.delegate = self
      
      cell.hourTextField.tag = indexPath.section + 1
      
      cell.minuteTextField.tag = -(indexPath.section + 1)
      
      cell.hourTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
      
      cell.minuteTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no

      cell.updateText(indexPath: spacedIndexPath)
      
      return cell
      
      
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoLablesWithButtonTableViewCell.identifier,
                                                     for: indexPath) as? TwoLablesWithButtonTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.timeSelectionViewModel = self.viewModel

      cell.updateText(indexPath: spacedIndexPath)
      
      return cell
    }
    
  }
}


extension TimeSelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12
  }
  //  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
  //
  //  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let inputText: String
    
    if pickerIndexPath == nil || pickerIndexPath != indexPath {
      inputText = viewModel.inputTexts[indexPath.section][indexPath.row]
    } else {
      inputText = viewModel.inputTexts[indexPath.section][indexPath.row - 1]
    }
    
    if inputText == "Day" {
      
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
    
  }
  func indexPathToInsertPicker(indexPath: IndexPath) -> IndexPath {
    
    return IndexPath(row: indexPath.row + 1, section: indexPath.section)
    
  }
}
extension TimeSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return DayOfWeek.allCases.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return DayOfWeek.allCases[row].title
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    viewModel.onDayChanged(day: row)
  }
}

extension TimeSelectionViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    //    tableView.beginUpdates()
    textField.text = ""
    
    if pickerIndexPath !=  nil {
      
      willExpand = false
      
      tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
      
      pickerIndexPath = nil
    }
  }
  
    func textFieldDidEndEditing(_ textField: UITextField) {

      if textField.tag > 0 {
        
        viewModel.onStartingTimeChanged(index: textField.tag - 1, hourInput: textField.text ?? "25")
        
      } else if textField.tag < 0 {
      
        viewModel.onStartingTimeChanged(index: abs(textField.tag) - 1, minuteInput: textField.text ?? "61")

      } else {
      
        assert(true) // some other text field ended editing?
      
      }
  }

  

  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    guard let textFieldText = textField.text,
      let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        return false
    }
    let substringToReplace = textFieldText[rangeOfTextToReplace]
    let count = textFieldText.count - substringToReplace.count + string.count
    return count <= 2
  }
}
