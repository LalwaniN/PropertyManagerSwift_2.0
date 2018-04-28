//
//  TenantHomeViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/21/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TenantHomeViewController: UIViewController {

    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var hamburgerViewBtn: UIBarButtonItem!
    var tenantUserName = ""
    var tenant: Tenant?
    var apartmentId: Int64?
    var propertyManagerUserName = ""
    var tenantList:[String] = []
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBAction func humburgerBtnAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            //self.viewConstraint.constant += 175
            //self.view.layoutIfNeeded()
            if(self.viewConstraint.constant >= 0){
                self.viewConstraint.constant = -175
                self.view.layoutIfNeeded()
            }else{
                self.viewConstraint.constant += 175
                self.view.layoutIfNeeded()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getApartmentById()
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.7
        sideView.layer.shadowOffset = CGSize(width:5 ,height:0)
        
        viewConstraint.constant = -175
        
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "bcgd3")?.alpha(0.7)
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {    //swipe right action
                if viewConstraint.constant < 20 {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                            self.viewConstraint.constant += translation / 10
                            self.view.layoutIfNeeded()
                        })
                }
            }else{  // swipe left action
                if viewConstraint.constant > -175 {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended {
            if viewConstraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewConstraint.constant = -175
                    self.view.layoutIfNeeded()
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    
    func getApartmentById(){
        print(apartmentId!)
        let ref: DatabaseReference =  Database.database().reference()
        ref.child("apartments").child(String(describing: self.apartmentId!)).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(!snapshot.hasChildren()){
                print("Error getting property ")
                return
            }
            self.propertyManagerUserName = value?["propertyManagerUserName"] as! String
            print("propertyManager : ---> \(self.propertyManagerUserName)")
            self.getTenantList()
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "chatBuddyIdentifier" {
            let controller = segue.destination as! ChatUserListControllerViewController
            tenantList.append(propertyManagerUserName)
            controller.userList = self.tenantList
            print(tenantList.count)
             print(self.apartmentId!)
            controller.apartmentId = self.apartmentId!
            controller.sourceEmail = tenantUserName
        }else if segue.identifier == "goToReportIssues" {
            let controller = segue.destination as! ReportIssuesViewController
            print(self.apartmentId!)
            controller.apartmentId = self.apartmentId!
        }else if segue.identifier == "goToHotDealsSegue"{
            let controller = segue.destination as! HotDealsViewController
            print(self.apartmentId!)
            controller.apartmentId = self.apartmentId!
        }
    }
    func getTenantList(){
        var ref: DatabaseReference =  Database.database().reference()
        ref = Database.database().reference().child("apartments")
        ref.queryOrdered(byChild: "propertyManagerUserName").queryEqual(toValue: self.propertyManagerUserName).observe(.childAdded, with: { (snapshot) in
            if(!snapshot.hasChildren()){
                print("No apartments available")
            }
            let values = snapshot.value as? NSDictionary
            print("--------------")
           // print(values!)
            var tempList = values!["tenantList"] as? [String]
            //print(tempList?.count)
            if(tempList != nil){
                for tenant in tempList!{
                    print("tenant")
                    print(tenant)
                    if(tenant != self.tenantUserName){
                        self.tenantList.append(tenant)
                    }
                }
            }
            
        })
    }
    

}
