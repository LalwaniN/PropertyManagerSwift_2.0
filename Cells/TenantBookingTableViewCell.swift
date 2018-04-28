//
//  TenantBookingTableViewCell.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

var globalPathString:String?

var firstnameArray: [Int:String] = [:]
var lastnameArray: [Int:String] = [:]
var usernamearray: [Int:String] = [:]
var passwordArray: [Int:String] = [:]
var contactNumberArray: [Int:Int64] = [:]
var imageArray: [Int:UIImage] = [:]

class TenantBookingTableViewCell: UITableViewCell,UITableViewDelegate,UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
    
    //Outlets
    @IBOutlet weak var tenantNumberLabel: UILabel!
    @IBOutlet weak var firstNameLabelCell: UITextField!
    @IBOutlet weak var lastNameLabelCell: UITextField!
    @IBOutlet weak var addressLine2TextField: UITextField!
    @IBOutlet weak var addressLine1TextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    
    @IBOutlet weak var uploadDocumentBtn: UIButton!
    @IBOutlet weak var DocumentPathLabel: UILabel!
    
    @IBOutlet weak var menuOutlet: UIButton!
    @IBOutlet var menuItemsOutlets: [UIButton]!
    
    
    //Actions
    @IBAction func menuItemsAction(_ sender: UIButton) {
        menuOutlet.titleLabel?.text = sender.titleLabel?.text
        
        menuItemsOutlets.forEach { (button) in
            UIView.animate(withDuration: 0.25, animations: {
                button.isHidden = !button.isHidden
                self.contentView.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        menuItemsOutlets.forEach { (button) in
            UIView.animate(withDuration: 0.25, animations: {
                button.isHidden = !button.isHidden
                self.contentView.layoutIfNeeded()
            })
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.uploadDocumentBtn.isHidden = !self.uploadDocumentBtn.isHidden
            self.contentView.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.25, animations: {
            self.DocumentPathLabel.isHidden = !self.DocumentPathLabel.isHidden
            self.contentView.layoutIfNeeded()
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func firstNameTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        if(sender.text == nil){
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    let alert = UIAlertController(title: "Alert", message: "Can't be empty!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    topController.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }else{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: sender.text!, options: [], range: NSMakeRange(0, sender.text!.characters.count)) != nil {
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            let alert = UIAlertController(title: "Alert", message: "Must not contain Number in Name", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            topController.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
            catch {
                
            }
        }
        firstnameArray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func lastNameTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        if(sender.text == nil){
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    let alert = UIAlertController(title: "Alert", message: "Can't be empty!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    topController.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }else{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: sender.text!, options: [], range: NSMakeRange(0, sender.text!.characters.count)) != nil {
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            let alert = UIAlertController(title: "Alert", message: "Must not contain Number in Name", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            topController.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
            catch {
                
            }
        }
        lastnameArray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func usernameTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        if(sender.text == nil){
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    let alert = UIAlertController(title: "Alert", message: "Can't be empty!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    topController.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }else{
            if(!isValidEmail(testStr: sender.text!)){
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        let alert = UIAlertController(title: "Alert", message: "NOT A VALID EMAIL!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        topController.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        usernamearray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func passwordTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        if(sender.text == nil){
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    let alert = UIAlertController(title: "Alert", message: "Can't be empty!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    topController.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }else{
            if(!isPasswordValid(sender.text!)){
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        let alert = UIAlertController(title: "Alert", message: "Password should contain 4 characters and should contain 1 alphabet and 1 spcial character !,@ !!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        topController.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        passwordArray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func contactTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        if(sender.text == nil){
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    let alert = UIAlertController(title: "Alert", message: "Can't be empty!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    topController.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }else{
            if let number = Int(sender.text!) {
                if(number < 0){
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            topController.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
                if(number>Int.max){
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            topController.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
                
                if(String(number).count>10 || String(number).count<10){
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            topController.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }else{
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        let alert = UIAlertController(title: "Alert", message: "Phone Number can contain onl digits!!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        topController.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        contactNumberArray[(indexPath?.row)!] = Int64(sender.text!)!
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[@!])[A-Za-z\\d@!]{4,}")
        return passwordTest.evaluate(with: password)
    }
    
    override func prepareForReuse(){
        //        super.prepareForReuse()
        //        self.firstNameLabelCell.text = ""
        //         self.lastNameLabelCell.text = ""
        //         self.addressLine2TextField.text = ""
        //         self.firstNameLabelCell.text = ""
        //         self.addressLine1TextField.text = ""
    }
    
    
}

