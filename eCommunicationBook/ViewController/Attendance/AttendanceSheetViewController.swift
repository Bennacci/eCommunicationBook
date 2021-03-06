//
//  AttendanceSheetViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/4.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class AttendanceSheetViewController: UIViewController, UICollectionGridViewSortDelegate {
    
    @IBOutlet weak var gridView: UIView!
    
    @IBOutlet weak var dropDownCourse: SwiftyMenu!
    
    @IBOutlet weak var dropDownCourseWidth: NSLayoutConstraint!
    
    var viewModel = AttendanceSheetViewModel()
    
    var gridViewController: UICollectionGridViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        viewModel.fetchCourse()
        
        viewModel.courseViewModel.bind { [weak self] _ in
            
            self?.setDropDown()
        }
        
        viewModel.studentAttendancesViewModel.bind { [weak self] _ in
            
            if self?.viewModel.selectedCourseIndex != nil {
            
                self?.viewModel.setAttendanceSheetContent()
            }
        }
        
        viewModel.refreshView = { [weak self] () in
            
            DispatchQueue.main.async {
                
                BTProgressHUD.dismiss()
                
                self?.addgridView()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func tapLeaveButton(_ sender: Any) {
    
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        
        if gridViewController != nil {
        
            gridViewController.view.frame = CGRect(x: 0,
                                                   y: 0,
                                                   width: gridView.frame.width,
                                                   height: gridView.frame.height)
        }
    }
    
    func addgridView() {
        
        gridViewController = UICollectionGridViewController()
        
        gridViewController.setColumns(columns: viewModel.columns)
        
        for index in 0 ..< viewModel.rows.count {
            
            gridViewController.addRow(row: viewModel.rows[index])
        }
        
        gridViewController.sortDelegate = self
        
        gridView.addSubview(gridViewController.view)
    }
    
    func setDropDown() {
        
        dropDownCourse.delegate = self
        
        dropDownCourse.items = self.viewModel.courseViewModel.value.map({$0.name})
        
        dropDownCourse.placeHolderText = "Select Course"
        
        dropDownCourse.separatorCharacters = " & "
        
        dropDownCourse.didSelectItem = { _, item, index in

            self.dropDownCourse.hideOptionsWhenSelect = false
            // There is some bug with the pod SwiftyMenu.
            // If toggle to true, dropdown does hideoptions after selecting a course.
            // But SwiftyMenuState in the pod isn't toggled
            // which causes dropdown expand/ collapse not working as expected.
            // To solve the issue "handleMenuState()" should be called as well!
            // PR to the pod has been made from KitsuneNoctus and expecting an updates very soon.
            // See https://github.com/KarimEbrahemAbdelaziz/SwiftyMenu/pull/24 for further informations.
            
            print("\(item) at index: \(index)")
        }
        
        modDropdow(dropDown: dropDownCourse)
    }
    
    func modDropdow(dropDown: SwiftyMenu) {
        
        // Custom Behavior
        dropDown.scrollingEnabled = true
        dropDown.isMultiSelect = false
        dropDown.hideOptionsWhenSelect = false
        
        // Custom UI
        dropDown.rowHeight = 38
        dropDown.listHeight = 340
        dropDown.borderWidth = 0.8
        
        // Custom Colors
        dropDown.borderColor = .black
        dropDown.itemTextColor = .black
        dropDown.placeHolderColor = .lightGray
        
        dropDown.borderColor = .black
        dropDown.itemTextColor = .black
        dropDown.placeHolderColor = .lightGray
        
        // Custom Animation
        dropDown.expandingAnimationStyle = .spring(level: .low)
        dropDown.expandingDuration = 0.5
        dropDown.collapsingAnimationStyle = .linear
        dropDown.collapsingDuration = 0.5
    }
    
    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]] {
        
        let sortedRows = rows.sorted { (firstRow: [Any], secondRow: [Any]) -> Bool in
            
            guard let firstRowValue = firstRow[colIndex] as? String,
                  let secondRowValue = secondRow[colIndex] as? String else {return true}
            
            if colIndex != rows[0].count - 1 {

                if asc {

                    return firstRowValue < secondRowValue
                }

                return firstRowValue > secondRowValue
            }
            
            let firstRowValuePercent = Double(firstRowValue[..<firstRowValue.endIndex])!

            let secondRowValuePercent = Double(secondRowValue[..<secondRowValue.endIndex])!
            
            if asc {
                
                return firstRowValuePercent < secondRowValuePercent
            }
            
            return firstRowValuePercent > secondRowValuePercent
        }
        
        return sortedRows
    }
}

// MARK: - SwiftMenuDelegate

extension AttendanceSheetViewController: SwiftyMenuDelegate {
    
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        
        viewModel.onCourseNameChanged(index: index)
        BTProgressHUD.show()
        print("Selected item: \(item), at index: \(index)")
    }
    
    func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {

        print("SwiftyMenu willExpand.")
    }
    
    func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {

        print("SwiftyMenu didExpand.")
    }
    
    func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
        
        print("SwiftyMenu willCollapse.")
    }
    
    func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didCollapse.")
    }
}
