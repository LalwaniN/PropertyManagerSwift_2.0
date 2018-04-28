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
        firstnameArray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func lastNameTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        lastnameArray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func usernameTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        usernamearray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func passwordTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        passwordArray[(indexPath?.row)!] = sender.text!
    }
    
    @IBAction func contactTextFieldEditing(_ sender: UITextField) {
        let cell = sender.superview?.superview as? UITableViewCell
        let tableView = cell?.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell!)
        print(indexPath?.row)
        contactNumberArray[(indexPath?.row)!] = Int64(sender.text!)!
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
