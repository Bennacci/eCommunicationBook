//
//  NewAClassViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class NewAClassViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController?.setNavigationBarHidden(false, animated: true)

        // Do any additional setup after loading the view.
    }
    
  @IBAction func pop(_ sender: Any) {
    print("hi")
    print(navigationController)
    self.navigationController?.popViewController(animated: true)

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
