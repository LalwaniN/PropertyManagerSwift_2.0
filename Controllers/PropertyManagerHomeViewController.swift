//
//  PropertyManagerHomeViewController.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/26/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import Firebase
class PropertyManagerHomeViewController: UIViewController {

    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var constraintForMenuView: NSLayoutConstraint!
    @IBOutlet weak var BlurView: UIVisualEffectView!
    @IBOutlet weak var SideView: UIView!
    
    
    var propManagerUserName = ""
    
    var tenantList:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        BlurView.layer.cornerRadius = 15
        SideView.layer.shadowColor = UIColor.black.cgColor
        SideView.layer.shadowOpacity = 0.7
        SideView.layer.shadowOffset = CGSize(width:5 ,height:0)
        
        constraintForMenuView.constant = -175
        
        self.hideKeyboardWhenTappedAround()
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "bcgd3")?.alpha(0.7)
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        getTenantList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        
        
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {    //swipe right action
                if constraintForMenuView.constant < 20 {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.constraintForMenuView.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else{  // swipe left action
                if constraintForMenuView.constant > -175 {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.constraintForMenuView.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended {
            if constraintForMenuView.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.constraintForMenuView.constant = -175
                    self.view.layoutIfNeeded()
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.constraintForMenuView.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func hamburgerMenuAction(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.2, animations: {
            //self.viewConstraint.constant += 175
            //self.view.layoutIfNeeded()
            if(self.constraintForMenuView.constant >= 0){
                self.constraintForMenuView.constant = -175
                self.view.layoutIfNeeded()
            }else{
                self.constraintForMenuView.constant += 175
                self.view.layoutIfNeeded()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "chatBuddyIdentifier" {
            
        }else if segue.identifier == "goToReportedIssuesView" {
           let controller = segue.destination as! ReportedIssuesForPropManagerViewController
             controller.propManagerUserName  = self.propManagerUserName
            print(self.propManagerUserName)
        }else if segue.identifier == "myPropertiesSegue"{
            let controller = segue.destination as! PropertyManagerViewController
            controller.propManagerUserName  = self.propManagerUserName
        }
        if segue.identifier == "chatBuddyPropertyManagerSegue" {
            let controller = segue.destination as! PMChatUserListViewController
            controller.userList = self.tenantList
            controller.propManagerUserName = self.propManagerUserName
            controller.sourceEmail = self.propManagerUserName
        }
    }

    func getTenantList(){
        var ref: DatabaseReference =  Database.database().reference()
        ref = Database.database().reference().child("apartments")
        ref.queryOrdered(byChild: "propertyManagerUserName").queryEqual(toValue: self.propManagerUserName).observe(.childAdded, with: { (snapshot) in
            if(!snapshot.hasChildren()){
                print("No apartments available")
            }
            let values = snapshot.value as? NSDictionary
            print("--------------")
            if(!((values!["tenantList"]) == nil)){
            let values1 = values!["tenantList"]! as? [String]
                let tempList = values!["tenantList"] as? [String]
                self.tenantList = tempList!
                print(self.tenantList)
            }
        })
    }

}
