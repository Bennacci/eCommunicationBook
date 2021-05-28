//
//  TimeSelectionViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/22.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit


// protocol TimeSelectionDelegate {
//  func didSelectTime()
// }

class TimeSelectionViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = TimeSelectionViewModel()
  
  var willExpand: Bool = false
  
  //  var forEvent: Bool = false
  
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
    tableView.registerCellWithNib(identifier: DatePickerTableViewCell.identifier, bundle: nil)
    //    viewModel.delegate = self
    viewModel.onDataUpdated = { [weak self] () in
      self?.tableView.reloadData()
    }
    //    viewModel.delegate = self
  }
  
  @IBAction func cancel(_ sender: Any) {
    guard let nav = navigationController, let _ = nav.topViewController else {
         return
     }
     nav.popViewController(animated: true)
//    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func add(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    
    viewModel.onSendAndQuit()
    if viewModel.forEvent == true {
      viewModel.delegate?.didSelectTime(for: "Event")
    } else {
      viewModel.delegate?.didSelectTime(for: "Course")
    }
  }
}

extension TimeSelectionViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    switch viewModel.forEvent {
    case true:
      return 1
    default:
      return viewModel.routineHours.count
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.forEvent == true {
      return viewModel.inputTextsForEvent.count
    } else if willExpand == true  && pickerIndexPath?.section == section {
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
    
    var inputText = ""
    
    if viewModel.forEvent == true {
      inputText = viewModel.inputTextsForEvent[indexPath.row]
    } else {
      inputText = viewModel.inputTexts[spacedIndexPath.section][spacedIndexPath.row]
    }
    
    if pickerIndexPath == indexPath {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PickerViewTableViewCell.identifier,
                                                     for: indexPath) as? PickerViewTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.pickerView.delegate = self
      
      cell.pickerView.selectRow(viewModel.routineHours[indexPath.section].day, inComponent: 0, animated: true)
      
      return cell
      
    } else if inputText == "Starting Time" || inputText == "Time Interval" {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeIntervalTableViewCell.identifier,
                                                     for: indexPath) as? TimeIntervalTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.timeSelectionViewModel = viewModel
      
      cell.hourTextField.delegate = self
      
      cell.minuteTextField.delegate = self
      
      cell.hourTextField.tag = indexPath.section * 10 + indexPath.row + 1
      
      cell.minuteTextField.tag = -(indexPath.section * 10 + indexPath.row + 1)
      
      cell.hourTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
      
      cell.minuteTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
      
      if inputText == "Starting Time"{
        
        cell.updateText(indexPath: spacedIndexPath)
        
      } else {
        
        cell.updateIntervalText(indexPath: spacedIndexPath)
      }
      
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
    
    if willExpand == true && indexPath.section == pickerIndexPath!.section && indexPath.row >= pickerIndexPath!.row {
      
      inputText = viewModel.inputTexts[indexPath.section][indexPath.row - 1]
      
    } else {
      
      if viewModel.forEvent == false {
        
        inputText = viewModel.inputTexts[indexPath.section][indexPath.row]
        
      } else {
        
        inputText = viewModel.inputTextsForEvent[indexPath.row]
      }
    }
    
    if inputText == "Day"{
      
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
    
    if inputText == "Delete"{
      
      viewModel.onAddorDeleteADay(day: indexPath.section)
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
    
    let pointInTable = pickerView.convert(pickerView.bounds.origin, to: self.tableView)
    
    guard let pickerVIewIndexPath = self.tableView.indexPathForRow(at: pointInTable) else {return}
    
    viewModel.onDayChanged(index: pickerVIewIndexPath.section, day: row)
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
    
    var tag = textField.tag
    
    if tag > 0 {
      
      if viewModel.forEvent == true {
      
        tag += 1
      }
      
      if (tag - 1) % 10 == 1 {
        
        viewModel.onStartingTimeChanged(index: (tag - 1) / 10, hourInput: textField.text ?? "-1")

      } else {
        
        viewModel.onTimeIntervalChanged(index: (tag - 1) / 10, hourInput: textField.text ?? "-1")
      }
      
    } else if tag < 0 {
      
      if viewModel.forEvent == true {
        
        tag -= 1
      }

      if (abs(tag) - 1) % 10 == 1 {
        
        viewModel.onStartingTimeChanged(index: (abs(tag) - 1) / 10, minuteInput: textField.text ?? "-1")
        
      } else {
        
        viewModel.onTimeIntervalChanged(index: (abs(tag) - 1) / 10, minuteInput: textField.text ?? "-1")

      }
      
    } else {
      
      assert(true) // some other text field ended editing?
    }
  }
}
