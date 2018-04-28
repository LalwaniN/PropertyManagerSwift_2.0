//
//  ViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/8/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

import FirebaseDatabase
import Firebase


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    @IBOutlet weak var hamburberView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    var row: Int = 0
    var apartments :[Apartment]?
    var strArray:[String] = ["1","2","3","4","5","6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.isHidden=true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.rowHeight = 206.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var hamburgerMenuIsVisible = false
    @IBAction func hamburgerBtnAction(_ sender: Any) {
        
        if !hamburgerMenuIsVisible {
            leadingC.constant = 150
            trailingC.constant = -150
            stackView.isHidden = false;
            hamburgerMenuIsVisible = true
        }else{
            leadingC.constant = 0;
            trailingC.constant = 0;
            stackView.isHidden=true
            hamburgerMenuIsVisible = false
        }
        
        UIView.animate(withDuration:0.2, delay: 0.0,options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) {(animationComplete) in
            print("The animation is complete!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as? propertyImagesViewCell
        
        cell?.labelString.sizeToFit()
        cell?.labelString.backgroundColor = UIColor.clear;
        cell?.labelString.adjustsFontSizeToFitWidth = true
        cell?.labelString?.text = "Saint Germain Street"
        cell?.propertyImageView.bringSubview(toFront: (cell?.labelString)!)
        cell?.propertyImageView.contentMode = .scaleAspectFit
        cell?.propertyImageView?.image = UIImage(named: strArray[indexPath.row])
        
        return cell!
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
}

class propertyImagesViewCell: UITableViewCell{
    @IBOutlet weak var propertyImageView: UIImageView!
    
    @IBOutlet weak var labelString: UILabel!
    
}

func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "showProperty" {
        let controller = segue.destination as! PropertyDetailViewController
        //if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
           // controller.apartment =
       // }
    }
}


