//
//  NewAClassViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import Lottie

class NewAThingViewController: UIViewController {
    
    @IBOutlet weak var viewConstruction: UIView!
    
    @IBOutlet weak var viewConstructionLottie: UIView!
    
    private var animationView: AnimationView?
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var buttonAdd: UIButton!
    
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
        
        viewModel.loadInitialValues()
        
        viewModel.onDataUpdated = { [weak self] () in

            self?.tableView.reloadData()
        }
        
        viewModel.onAdded = { [weak self] () in

            self?.delegate?.onPublished()

            self?.navigationController?.popViewController(animated: true)
        }
        
        if viewModel.inputTexts[0].count == 0 {

            addConstructionView()

            buttonBack.setTitle("Back", for: .normal)

            buttonAdd.isHidden = true
        }
    }
    
    func addConstructionView() {

        viewConstruction.isHidden = false

        animationView = .init(name: "construction")
        
        animationView!.frame = viewConstructionLottie.bounds
                
        animationView!.contentMode = .scaleAspectFit
                
        animationView!.loopMode = .loop
                
        animationView!.animationSpeed = 0.5
        
        viewConstructionLottie.addSubview(animationView!)
       
        viewConstructionLottie.layoutIfNeeded()
        
        viewConstruction.layoutIfNeeded()
        
        animationView!.play()
    }
    
    @IBAction func cancel(_ sender: Any) {
                
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func send(_ sender: Any) {
        
        viewModel.onTapAdd(thing: self.navigationItem.title!)
    }
}

// swiftlint:disable function_body_length cyclomatic_complexity
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
            
            case "Birth Date", "First Lesson Date", "Date":
                let cell: DatePickerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.updateCell(date: inputDate, indexPath: indexPath)
                cell.delegate = self
                return cell
                
            case "User Type":
                let cell: PickerViewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.updateCell(indexPath: indexPath)
                cell.pickerView.delegate = self
                return cell
                
            default:
                let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }
            
        } else if inputText == "Birth Date" || inputText == "User Type" ||
                    inputText == "First Lesson Date" || inputText == "Date" {
            
            let cell: TwoLablesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            switch inputText {
            
            case "User Type":
                cell.updateText(text: inputText, type: viewModel.user.userType!)
                return cell
                
            default:
                cell.updateText(text: inputText, date: inputDate)
                return cell
            }
            
        } else if inputText == "Teachers" || inputText == "Students" ||
                    inputText == "Lesson Schedule" || inputText == "Time" {
            
            let cell: TwoLablesWithButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateText(text: inputText)
            return cell
            
        } else {
            
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.textField.placeholder = "tap to edit"
            cell.title.text = inputText
            cell.textField.delegate = self
            
            switch inputText {
            
            case "CellPhone Number", "Contact Number", "Grade", "Total Lesson Count", "Fee":
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
        
        let inputText = viewModel.inputTexts[indexPath.section][indexPath.row]
        
        if inputText == "User Type" || inputText == "Birth Date" ||
            inputText == "First Lesson Date" || inputText == "Date" {
            
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
        
        if inputText == "Teachers" || inputText == "Students"{
            
            if let nextVC = UIStoryboard.searchUser.instantiateInitialViewController() {
                
                guard let targetController = nextVC.children[0] as? SearchUserViewController
                
                else { fatalError("Unexpected Table View Cell") }
                
                targetController.delegate = self.viewModel
                
                if inputText == "Teachers"{
                    
                    targetController.viewModel.forStudent = false
                    
                } else {
                    
                    targetController.viewModel.forStudent = true
                }
                
                self.navigationController?.show(nextVC, sender: nil)
                
            } else { return }
            
        } else if inputText == "Lesson Schedule" || inputText == "Time" {
            
            if let nextVC = UIStoryboard.timeSelection.instantiateInitialViewController() {
                
                guard let targetController = nextVC.children[0] as? TimeSelectionViewController
                
                else { fatalError("Unexpected Table View Cell") }
                
                if inputText == "Time" {
                    
                    targetController.viewModel.forEvent = true
                }
                
                targetController.viewModel.delegate = self
                
                if UserManager.shared.selectedDays != nil {
                    
                    targetController.viewModel.routineHours = UserManager.shared.selectedDays!
                    
                    targetController.viewModel.loadInitialValues()
                }
                
                self.navigationController?.show(nextVC, sender: nil)
                
            } else {
                
                return
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        if pickerIndexPath !=  nil {
            
            willExpand = false
            
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            
            pickerIndexPath = nil
        }
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
            viewModel.onStudentNameChanged(text: info)
        case "National ID":
            viewModel.onStudentNationalIDChanged(text: info)
        case "Grade":
            viewModel.onStudentGradeChanged(text: info)
        case "Emergency Contact Person":
            viewModel.onStudentContactPersonChanged(text: info)
        case "ID":
            viewModel.onUserIDChanged(text: info)
        case "E-mail":
            viewModel.onEmailChanged(text: info)
        case "CellPhone Number":
            viewModel.onCellPhoneNoChanged(text: info)
        case "Contact Number":
            viewModel.onHomePhoneNoChanged(text: info)
            viewModel.onStudentContactNoChanged(text: info)
        case "Class Name":
            viewModel.onCourseNameChanged(text: info)
        case "Total Lessons Count":
            viewModel.onLessonsAmountChanged(text: info)
        case "Fee":
            viewModel.onFeeChanged(text: info)
        case "Title":
            viewModel.onEventNameChanged(text: info)
        case "Description":
            viewModel.onEventDiscriptionChanged(text: info)
        default:
            return
        }
    }
}

extension NewAThingViewController: TimeSelectionDelegate {
    
    func didSelectTime(for thing: String) {

        if thing == "Course"{

            viewModel.onCourseTimeChanged(time: UserManager.shared.selectedDays ?? [])

        } else {

            guard let selectedDays = UserManager.shared.selectedDays else {return}

            viewModel.onEventTimeChanged(time: selectedDays[0])
        }

        tableView.reloadData()
    }
}

extension NewAThingViewController: PickerDelegate {
    
    func didChangeData(type: UserType, indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        
        switch viewModel.inputTexts[indexPath.section][indexPath.row] {
        
        case "Birth Date":
            viewModel.onBirthDayChanged(day: date)
            viewModel.onStudentBirthDayChanged(day: date)
            viewModel.inputDates[indexPath.section][indexPath.row] = date
            tableView.reloadRows(at: [indexPath], with: .none)
       
        case "First Lesson Date":
            viewModel.onFirstLessonDateChanged(day: date)
            viewModel.inputDates[indexPath.section][indexPath.row] = date
            tableView.reloadRows(at: [indexPath], with: .none)
        
        case "Date":
            viewModel.onEventDateChanged(day: date)
            viewModel.inputDates[indexPath.section][indexPath.row] = date
            tableView.reloadRows(at: [indexPath], with: .none)
        
        default:
            return
        }
    }
}
// swiftlint:enable function_body_length cyclomatic_complexity

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
