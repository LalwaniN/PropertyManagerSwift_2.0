//
//  BaseViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_button")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(BaseViewController.onMenu(_:)))
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.layer.shadowOpacity = 1.0
        navigationController?.navigationBar.layer.shadowRadius = 1.0
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Actions
    @IBAction func onMenu(_ sender: AnyObject) {
        if slidingPanelController.sideDisplayed == MSSPSideDisplayed.left {
            slidingPanelController.closePanel()
        } else {
            slidingPanelController.openLeftPanel()
        }
    }
}
