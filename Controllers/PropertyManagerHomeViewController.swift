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

    override func viewDidLoad() {
        super.viewDidLoad()
        BlurView.layer.cornerRadius = 15
        SideView.layer.shadowColor = UIColor.black.cgColor
        SideView.layer.shadowOpacity = 0.7
        SideView.layer.shadowOffset = CGSize(width:5 ,height:0)
        
        constraintForMenuView.constant = -175
        
        
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
            
        }else if segue.identifier == "goToReportIssues" {
            //let controller = segue.destination as! RepotedIssuesViewController
            
        }else if segue.identifier == "myPropertiesSegue"{
            let controller = segue.destination as! PropertyManagerViewController
            controller.propManagerUserName  = self.propManagerUserName

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
