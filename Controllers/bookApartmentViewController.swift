//
//  bookApartmentViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class bookApartmentViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var pathArray: [Int:String]? = [:]{
        didSet{
            let indexPath = IndexPath(row: index!, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? TenantBookingTableViewCell
            cell?.DocumentPathLabel.text = pathArray![index!]
            //tableView.reloadData()
        }
    }
    
    var images: [Int:UIImage]? = [:]
    var index: Int?
    
    let imagePicker = UIImagePickerController()
    var tenant :Tenant?
    var value:String? = "0"
    var row: Int = 0
    var apartment : Apartment?
    
    //Outlets
    @IBOutlet weak var menuOutlet: UIButton!
    @IBOutlet var menuItemsOutlets: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    
    //Actions
    @IBAction func menuAction(_ sender: Any) {
        menuItemsOutlets.forEach { (button) in
            UIView.animate(withDuration: 0.45, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func submitDetailsBtn(_ sender: Any) {
        print(value!)
        
        for i in 0..<Int(value!)!{
            tenant = Tenant()
            tenant?.firstName = firstnameArray[i]
            tenant?.lastName = lastnameArray[i]
            tenant?.userName = usernamearray[i]
            tenant?.password = passwordArray[i]
            tenant?.documentImage = imageArray[i]
            tenant?.phone = contactNumberArray[i]
            tenant?.role = Role.Tenant
            //temporary
//            tenant?.identityDocument = "https://firebasestorage.googleapis.com/v0/b/swiftfinalproject-c347c.appspot.com/o/NxFXi5Lg.png?alt=media&token=2db1151f-6b97-46ae-8aa6-c14ebbe37985"
            //temporary
           // tenant?.saveToFirebase()
            tenant?.apartmentId = self.apartment?.apartmentId!
            tenant?.saveImagetoFirebase()
            apartment?.tenantList.append((tenant?.userName!)!)
            apartment?.isRented = true
            apartment?.saveToFirebase()
        }
//            tenant = Tenant()
//            let cell = tableView.cellForRow(at: IndexPath(row: i,section: 0)) as! TenantBookingTableViewCell
//            tenant?.firstName = cell.firstNameLabelCell.text!
//            print(cell.firstNameLabelCell.text!)
//            print((tenant?.firstName)!)
//            tenant?.lastName = cell.lastNameLabelCell.text!
//            tenant?.userName = cell.addressLine1TextField.text!
//            tenant?.password = cell.addressLine2TextField.text!
//            tenant?.phone = Int64(cell.contactNumberTextField.text!)
//            if (images?[i]) != nil{
//                 tenant?.documentImage = images?[i]
//            }else{
//                tenant?.documentImage = UIImage(named: "defaultDoc")
//            }
//
//            tenant?.apartmentId = apartment?.apartmentId
//            tenant?.role = Role.Tenant
//            //temporary
//            tenant?.identityDocument = "https://firebasestorage.googleapis.com/v0/b/swiftfinalproject-c347c.appspot.com/o/NxFXi5Lg.png?alt=media&token=2db1151f-6b97-46ae-8aa6-c14ebbe37985"
//            //temporary
//            tenant?.saveToFirebase()
//            //tenant?.saveImagetoFirebase()
//            apartment?.tenantList.append((tenant?.userName!)!)
//            apartment?.isRented = true
//            apartment?.saveToFirebase()
//        }
    }
    
    @IBAction func uploadDocBtnAction(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        //imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        print(1)
        let parentView = sender.superview?.superview?.superview as! UITableViewCell
        let indexPath1 = tableView.indexPath(for: parentView)
        index = indexPath1?.row
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
         if let selectedImage = selectedImageFromPicker{
            imageArray[index!] = selectedImage
            globalPathString = ""
            let url: NSURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
            print(url.absoluteString ?? "")
            globalPathString = url.absoluteString
            print(globalPathString!)
            print(index!)
            pathArray![index!] = globalPathString!
            images![index!] = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuItemsActions(_ sender: UIButton) {
        menuItemsOutlets.forEach { (button) in
            UIView.animate(withDuration: 0.45, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        value = sender.titleLabel?.text
        menuOutlet.titleLabel?.text = value!
        tableView.dataSource = self
        tableView.estimatedRowHeight = 650
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setContentOffset(tableView.contentOffset, animated: false)
        imagePicker.delegate = self
        menuOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //tableView.dataSource = self
       tableView.estimatedRowHeight = 650
    
       tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backButtonBookSegue" {
            let controller = segue.destination as! PropertyDetailViewController
            controller.apartment = apartment
            
        }
    }

}

extension bookApartmentViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(value!)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as! TenantBookingTableViewCell
        self.tableView.rowHeight = 650
        cell.tenantNumberLabel.text = "--------TENANT NO. \(indexPath.row + 1)--------"
        cell.setTransparent()
        cell.menuOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

extension UITableViewCell {
    func setTransparent() {
        let bgView: UIView = UIView()
        bgView.backgroundColor = .clear
        
        self.backgroundView = bgView
        self.backgroundColor = .clear
    }
}
