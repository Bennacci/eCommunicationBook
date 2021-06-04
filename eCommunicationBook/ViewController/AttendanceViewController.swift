//
//  AttendanceViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/4.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

// 多列表格组件（通过CollectionView实现）
class AttendanceViewController: UIViewController, UICollectionGridViewSortDelegate {
  
  @IBOutlet weak var dropDownCourse: SwiftyMenu!
  
  var viewModel = AttendanceViewControllerViewModel()
  
  var gridViewController: UICollectionGridViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.fetchCourse()
    
    
    
    // "✅",  "☑️  ", "❌"
    gridViewController = UICollectionGridViewController()
    gridViewController.setColumns(columns: ["编号", "客户", "消费金额", "消费次数", "满意度"])
    gridViewController.addRow(row: ["No.01", "✅", "☑️  ", "🅻⃝", "❌", "60%"])
    gridViewController.addRow(row: ["No.02", "张三⭕️ ✅", "✔️", "16", "81%"])
    gridViewController.addRow(row: ["No.03", "李四", "⭕️", "25", "93%"])
    gridViewController.addRow(row: ["No.04", "王五", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.05", "韩梅梅", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.06", "李雷", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.07", "王大力", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.08", "蝙蝠侠", "100", "8", "60%"])
    gridViewController.addRow(row: ["No.09", "超人", "223", "16", "81%"])
    gridViewController.addRow(row: ["No.10", "钢铁侠", "143", "25", "93%"])
    gridViewController.addRow(row: ["No.11", "灭霸", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.12", "快银", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.13", "闪电侠", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.14", "绿箭", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.15", "绿巨人", "223", "16", "81%"])
    gridViewController.addRow(row: ["No.16", "黑寡妇", "143", "5", "93%"])
    gridViewController.addRow(row: ["No.17", "企鹅人", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.18", "双面人", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.19", "奥特曼", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.20", "小怪兽s", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.16", "黑寡妇", "143", "5", "93%"])
    gridViewController.addRow(row: ["No.17", "企鹅人", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.18", "双面人", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.19", "奥特曼", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.20", "小怪兽s", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.16", "黑寡妇", "143", "5", "93%"])
    gridViewController.addRow(row: ["No.17", "企鹅人", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.18", "双面人", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.19", "奥特曼", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.20", "小怪兽s", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.16", "黑寡妇", "143", "5", "93%"])
    gridViewController.addRow(row: ["No.17", "企鹅人", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.18", "双面人", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.19", "奥特曼", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.20", "小怪兽s", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.16", "黑寡妇", "143", "5", "93%"])
    gridViewController.addRow(row: ["No.17", "企鹅人", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.18", "双面人", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.19", "奥特曼", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.20", "小怪兽s", "33", "22", "15%"])
    gridViewController.addRow(row: ["No.16", "黑寡妇", "143", "5", "93%"])
    gridViewController.addRow(row: ["No.17", "企鹅人", "75", "2", "53%"])
    gridViewController.addRow(row: ["No.18", "双面人", "43", "12", "33%"])
    gridViewController.addRow(row: ["No.19", "奥特曼", "33", "27", "45%"])
    gridViewController.addRow(row: ["No.20", "小怪兽s", "33", "22", "15%"])
    gridViewController.sortDelegate = self
    view.addSubview(gridViewController.view)
  }
  
  
  
  override func viewDidLayoutSubviews() {
    gridViewController.view.frame = CGRect(x: 0,
                                           y: 64,
                                           width: view.frame.width,
                                           height: view.frame.height-64)
  }

  
  func setDropDown() {
    
    // Setup component
    dropDownCourse.delegate = self
    
    dropDownCourse.items = self.viewModel.courseViewModel.value.map({$0.name})
    
    dropDownCourse.placeHolderText = "Please Select Course"

    dropDownCourse.separatorCharacters = " & "
    
    // Support CallBacks
    dropDownCourse.didExpand = {
      print("SwiftyMenu Expanded!")
    }
    
    dropDownCourse.didCollapse = {
      print("SwiftyMenu Collapsed!")
    }
    
    dropDownCourse.didSelectItem = { _, item, index in
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

  // 表格排序函数
  func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]] {
    let sortedRows = rows.sorted { (firstRow: [Any], secondRow: [Any])
      -> Bool in
      guard let firstRowValue = firstRow[colIndex] as? String,
        let secondRowValue = secondRow[colIndex] as? String else {return true}
      if colIndex == 0 || colIndex == 1 {
        // 首例、姓名使用字典排序法
        if asc {
          return firstRowValue < secondRowValue
        }
        return firstRowValue > secondRowValue
      } else if colIndex == 2 || colIndex == 3 {
        // 中间两列使用数字排序
        if asc {
          return Int(firstRowValue)! < Int(secondRowValue)!
        }
        return Int(firstRowValue)! > Int(secondRowValue)!
      }
      // 最后一列数据先去掉百分号，再转成数字比较
      let firstRowValuePercent = Int(firstRowValue.substring(to:
        firstRowValue.index(before: firstRowValue.endIndex)))!
      let secondRowValuePercent = Int(secondRowValue.substring(to:
        secondRowValue.index(before: secondRowValue.endIndex)))!
      if asc {
        return firstRowValuePercent < secondRowValuePercent
      }
      return firstRowValuePercent > secondRowValuePercent
    }
    return sortedRows
  }
}

// MARK: - SwiftMenuDelegate

extension AttendanceViewController: SwiftyMenuDelegate {
  func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {

    viewModel.onCourseNameChanged(index: index)
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
