//
//  LessonPlanDetail.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LessonPlanDetailViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: LessonPlanDetailViewModel?
  
  let publishBV: SaveButtonView = {
    let view = SaveButtonView()
    view.frame = CGRect(x: UIScreen.main.bounds.width - 66,
                        y: UIScreen.main.bounds.height - 86,
                        width: 50,
                        height: 50)
    view.backgroundColor = .clear
    view.initSubView()
    view.saveButton.addTarget(self, action: #selector(saveLessonPlanDetail), for: .touchUpInside)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerCellWithNib(identifier: AddRowTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: LessonPlanDetailTableViewCell.identifier, bundle: nil)
    
    addSaveButton()
  }
  
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
  }
  
  func addSaveButton() {
    self.view.addSubview(publishBV)
  }
  
  @objc func saveLessonPlanDetail(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}


extension LessonPlanDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Todays's Lesson"
    case 1:
      return "Today's Homework"
    default:
      return "Test"
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRowTableViewCell.identifier,
                                                        for: indexPath) as? AddRowTableViewCell
      else { fatalError("Unexpected Table View Cell") }

    return cell
  }
  
  
}

extension LessonPlanDetailViewController: UITableViewDelegate {
  
}
