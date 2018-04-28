//
//  PMChatLogViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/28/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class PMChatLogViewController: UIViewController {
    
    var propManagerUserName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToPropertyManagerHome" {
            let controller = segue.destination as! PMChatUserListViewController
            controller.propManagerUserName = self.propManagerUserName
        }
    }
}
