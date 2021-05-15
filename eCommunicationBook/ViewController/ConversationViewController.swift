//
//  ConversationViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

  @IBOutlet weak var conversationTableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController?.navigationBar.backgroundColor = UIColor(white: 0.0, alpha: 0)
      conversationTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));

//      self.navigationController?.setNavigationBarHidden(true, animated: true)
//      self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 0)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationViewController: UITableViewDelegate {
  
}
extension ConversationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 1 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: UserMessageTableViewCell.identifier,for: indexPath) as? UserMessageTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));

      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PartnerMessageTableViewCell.identifier, for: indexPath) as? PartnerMessageTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));

      return cell
    }
  }
}
