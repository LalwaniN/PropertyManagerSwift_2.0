//
//  ReportIssuesViewController.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/27/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class ReportIssuesViewController: UIViewController ,UIImagePickerControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
    }
    var apartmentId: Int64?
    var request : MaintenanceRequest?
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var reportIssueButton: UIButton!
    @IBOutlet weak var issueImage: UIButton!
    @IBOutlet weak var issueImageLable: UILabel!
    @IBOutlet weak var issueDescription: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        request = MaintenanceRequest()
        
        pickerData = ["Pest Control", "Appliance Repair", "Plumbing", "Carpet Cleaning", "Noise Issue"]
        // Do any additional setup after loading the view.
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "od2")?.alpha(0.4)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        issueImage.layer.cornerRadius = 15
        reportIssueButton.layer.cornerRadius = 15
        self.view.addSubview(imageViewBackground)
         self.view.sendSubview(toBack: imageViewBackground)
        imagePicker.delegate = self
    
    }
    @IBAction func imagePickerAction(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //let titleData = pickerData[row]
        //let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
       // return myTitle
      return pickerData[row]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        let selectedValue = pickerData[pickerView.selectedRow(inComponent: component)] as String!
        //print(selectedValue!)
        request?.requestType = selectedValue! ?? pickerData[pickerView.selectedRow(inComponent: 0)] as String!
    }
    

    @IBAction func reportIssueAction(_ sender: Any) {
        
     request?.apartmentId = apartmentId
     request?.requestDescription = issueDescription.text!
     request?.saveImagetoFirebase()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.request?.requestImage = pickedImage
            let url: NSURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
            issueImageLable.text = url.absoluteString!
        }else{
            self.request?.requestImage = UIImage(named: "defaultpropertyimage")
            let url: NSURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
            issueImageLable.text = url.absoluteString!
        }
        dismiss(animated: true, completion: nil)
    }
}


