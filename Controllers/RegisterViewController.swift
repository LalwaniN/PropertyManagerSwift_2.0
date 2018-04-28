//
//  RegisterViewController.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/10/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import Firebase
import Photos
import FirebaseDatabase
import CoreLocation
import Foundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension String {
    func randomNumericInt() -> Int {
        let charactersString = "0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<4 {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return Int(string)!
    }
    
    
}

var i = 0{
    didSet{

    }
}

var appearFlag: Bool = false
class RegisterViewController: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,XMLParserDelegate{

    let propertyManager = PropertyManager()
    let address = Address()
    let apartmentAddress = Address()
    
    var apartment = Apartment()
    
    var ref:DatabaseReference?
    let imagePicker = UIImagePickerController()
    func presentAlert(){
        let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY REGISTERED PROPERTY MANAGER!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var managementNameTextField: UITextField!
    @IBOutlet weak var profileImageNameLabel: UILabel!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressLine2TextField: UITextField!
    @IBOutlet weak var addressLine1TextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        emailTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        managementNameTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        addressLine2TextField.resignFirstResponder()
        addressLine1TextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        //Setting Delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        managementNameTextField.delegate = self
        postalCodeTextField.delegate = self
        stateTextField.delegate = self
        cityTextField.delegate = self
        addressLine2TextField.delegate = self
        addressLine1TextField.delegate = self
        phoneTextField.delegate = self
        
        let blueColor : UIColor = UIColor( red: 68.0/255, green: 126.0/255, blue:194.0/255, alpha: 1.0 )
        
        //Implementing Layers,Border Color & Width
        emailTextField.layer.borderColor = blueColor.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 15
        confirmPasswordTextField.layer.borderColor = blueColor.cgColor
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.cornerRadius = 15
        passwordTextField.layer.borderColor = blueColor.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 15
        managementNameTextField.layer.borderColor = blueColor.cgColor
        managementNameTextField.layer.borderWidth = 1
        managementNameTextField.layer.cornerRadius = 15
        postalCodeTextField.layer.borderColor = blueColor.cgColor
        postalCodeTextField.layer.borderWidth = 1
        postalCodeTextField.layer.cornerRadius = 15
        stateTextField.layer.borderColor = blueColor.cgColor
        stateTextField.layer.borderWidth = 1
        stateTextField.layer.cornerRadius = 15
        cityTextField.layer.borderColor = blueColor.cgColor
        cityTextField.layer.borderWidth = 1
        cityTextField.layer.cornerRadius = 15
        addressLine2TextField.layer.borderColor = blueColor.cgColor
        addressLine2TextField.layer.borderWidth = 1
        addressLine2TextField.layer.cornerRadius = 15
        addressLine1TextField.layer.borderColor = blueColor.cgColor
        addressLine1TextField.layer.borderWidth = 1
        addressLine1TextField.layer.cornerRadius = 15
        phoneTextField.layer.borderColor = blueColor.cgColor
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.cornerRadius = 15
        
        uploadImageButton.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 15
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "od2")?.alpha(0.7)
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        registerLabel.center.y -= view.bounds.width
        emailTextField.center.x += view.bounds.width
        confirmPasswordTextField.center.x -= view.bounds.width
        passwordTextField.center.x += view.bounds.width
        managementNameTextField.center.x += view.bounds.width
        postalCodeTextField.center.x -= view.bounds.width
        stateTextField.center.x -= view.bounds.width
        cityTextField.center.x += view.bounds.width
        addressLine2TextField.center.x += view.bounds.width
        addressLine1TextField.center.x -= view.bounds.width
        phoneTextField.center.x -= view.bounds.width
        registerButton.alpha = 0.0
        uploadImageButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(!appearFlag){
            registerButton.center.x = self.view.center.x
            uploadImageButton.center.x = self.view.center.x
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 2.0, animations: {
                self.registerLabel.center.y += self.view.bounds.width
                if(self.registerLabel.center.x != self.view.center.x){
                    self.registerLabel.center.x = self.view.center.x
                }
            })
            
            UIView.animate(withDuration: 1.5, delay: 0.5,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
                            self.emailTextField.center.x -= self.view.bounds.width
                            self.passwordTextField.center.x -= self.view.bounds.width
                            self.confirmPasswordTextField.center.x += self.view.bounds.width
                            self.managementNameTextField.center.x -= self.view.bounds.width
                            self.postalCodeTextField.center.x += self.view.bounds.width
                            self.stateTextField.center.x += self.view.bounds.width
                            self.cityTextField.center.x -= self.view.bounds.width
                            self.addressLine2TextField.center.x -= self.view.bounds.width
                            self.addressLine1TextField.center.x += self.view.bounds.width
                            self.phoneTextField.center.x += self.view.bounds.width
                            
                            if(self.emailTextField.center.x != self.view.center.x){
                                self.emailTextField.center.x = self.view.center.x
                            }
                            if(self.passwordTextField.center.x != self.view.center.x){
                                self.passwordTextField.center.x = self.view.center.x
                            }
                            if(self.confirmPasswordTextField.center.x != self.view.center.x){
                                self.confirmPasswordTextField.center.x = self.view.center.x
                            }
                            if(self.managementNameTextField.center.x != self.view.center.x){
                                self.managementNameTextField.center.x = self.view.center.x
                            }
                            if(self.cityTextField.center.x != self.view.center.x){
                                self.cityTextField.center.x = self.view.center.x
                            }
                            if(self.addressLine2TextField.center.x != self.view.center.x){
                                self.addressLine2TextField.center.x = self.view.center.x
                            }
                            if(self.addressLine1TextField.center.x != self.view.center.x){
                                self.addressLine1TextField.center.x = self.view.center.x
                            }
                            if(self.phoneTextField.center.x != self.view.center.x){
                                self.phoneTextField.center.x = self.view.center.x
                            }
                            
                            if(self.postalCodeTextField.center.x != self.view.center.x){
                                self.postalCodeTextField.center.x = self.view.center.x
                            }
                            if(self.stateTextField.center.x != self.view.center.x){
                                self.stateTextField.center.x = self.view.center.x
                            }
                           
                            self.view.layoutIfNeeded()
                            
            }, completion: nil)
            
            UIView.animate(withDuration: 1.0, delay: 2.0,
                           options: [],
                           animations: {
                            self.registerButton.alpha = 1.0
                            self.uploadImageButton.alpha = 1.0
            }, completion: nil)
        }else{
            registerLabel.center.y = 40.0
            registerLabel.center.x = self.view.center.x
            registerButton.center.x = self.view.center.x
            uploadImageButton.center.x = self.view.center.x
            self.registerButton.alpha = 1.0
            self.uploadImageButton.alpha = 1.0
            if(self.emailTextField.center.x != self.view.center.x){
                self.emailTextField.center.x = self.view.center.x
            }
            if(self.passwordTextField.center.x != self.view.center.x){
                self.passwordTextField.center.x = self.view.center.x
            }
            if(self.confirmPasswordTextField.center.x != self.view.center.x){
                self.confirmPasswordTextField.center.x = self.view.center.x
            }
            if(self.managementNameTextField.center.x != self.view.center.x){
                self.managementNameTextField.center.x = self.view.center.x
            }
            if(self.cityTextField.center.x != self.view.center.x){
                self.cityTextField.center.x = self.view.center.x
            }
            if(self.addressLine2TextField.center.x != self.view.center.x){
                self.addressLine2TextField.center.x = self.view.center.x
            }
            if(self.addressLine1TextField.center.x != self.view.center.x){
                self.addressLine1TextField.center.x = self.view.center.x
            }
            if(self.phoneTextField.center.x != self.view.center.x){
                self.phoneTextField.center.x = self.view.center.x
            }
            
            if(self.postalCodeTextField.center.x != self.view.center.x){
                self.postalCodeTextField.center.x = self.view.center.x
            }
            if(self.stateTextField.center.x != self.view.center.x){
                self.stateTextField.center.x = self.view.center.x
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "backFromRegisterSegue") {
            appearFlag = false
        }
    }
    
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        managementNameTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        addressLine1TextField.resignFirstResponder()
        addressLine2TextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true;
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
    
    @IBAction func registerAction(_ sender: UIButton) {
        
        if((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmPasswordTextField.text?.isEmpty)! || (managementNameTextField.text?.isEmpty)! || (postalCodeTextField.text?.isEmpty)! || (stateTextField.text?.isEmpty)! || (cityTextField.text?.isEmpty)! || (phoneTextField.text?.isEmpty)! || (addressLine1TextField.text?.isEmpty)!){
            let alert = UIAlertController(title: "Alert", message: "Fields are mandatory!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if(!isValidEmail(testStr: emailTextField.text!)){
            let alert = UIAlertController(title: "Alert", message: "E-Mail Address not valid!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if(!(passwordTextField.text?.elementsEqual(confirmPasswordTextField.text!))!){
            let alert = UIAlertController(title: "Alert", message: "Password and Confirm Password should match!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if(!(isPasswordValid(passwordTextField.text!))){
            let alert = UIAlertController(title: "Alert", message: "Password should contain 4 characters and should contain 1 alphabet and 1 spcial character !,@ !!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if let number = Int(phoneTextField.text!) {
            if(number < 0){
                let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if(number>Int.max){
                let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            if(String(number).count>10 || String(number).count<10){
                let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Phone Number can contain only numbers!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if let number = Int(postalCodeTextField.text!) {
            if(number < 0){
                let alert = UIAlertController(title: "Alert", message: "Invalid Postal Code!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if(number>Int.max){
                let alert = UIAlertController(title: "Alert", message: "Invalid Postal Code!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            if(postalCodeTextField.text!.count != 5){
                let alert = UIAlertController(title: "Alert", message: "Invalid Postal Code!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Postal Code can contain only Numbers!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    

        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        
        
        let coor:String = "" + addressLine1TextField.text! + ", " + cityTextField.text! + ", " + stateTextField.text! + " " + postalCodeTextField.text!
        print(coor)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(coor) { (placemarks, error) in
            guard let placemarks = placemarks,let location = placemarks.first?.location
                else {
                    let alert = UIAlertController(title: "ALERT", message: "PLEASE ENTER A VALID ADDRESS!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            self.address.addressLine1 = self.addressLine1TextField.text
            self.address.addressLine2 = self.addressLine2TextField.text
            self.address.city = self.cityTextField.text
            self.address.state = self.stateTextField.text
            self.address.postalCode = Int(self.postalCodeTextField.text!)
            self.address.latitude = Double(location.coordinate.latitude)
            self.address.longitude = Double(location.coordinate.longitude)
            self.propertyManager.address = self.address
            
            self.propertyManager.name = self.managementNameTextField.text
            self.propertyManager.apartmentList = []
            self.propertyManager.allRequests = []
            let email = self.emailTextField.text?.replacingOccurrences(of: ".", with: ",")
            self.propertyManager.userName = email
            self.propertyManager.password = self.passwordTextField.text
            self.propertyManager.phone = Int64(self.phoneTextField.text!)
            self.propertyManager.role = Role.PropertyManager
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            var userName : String = self.emailTextField.text!
            userName = userName.replacingOccurrences(of: ".", with: ",")
            ref?.child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if(snapshot.hasChildren()){
                    let alert = UIAlertController(title: "ALERT", message: "EMAIL ALREADY REGISTERED FOR PROPERTY MANAGER!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                if self.propertyManager.profileImage1 == nil {
                    self.propertyManager.profileImage1 = UIImage(named: "1")!
                }
                self.propertyManager.saveImagetoFirebase()
                appearFlag = true;
                self.getProperties()
            })
        }
    }
    
    @IBAction func uploadProfileImageButtonAction(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        appearFlag = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectedImagePath: UILabel!
    @IBOutlet weak var propertyImageView: UIImageView!
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            propertyManager.profileImage1 = selectedImage
            let url: NSURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
            //print(url.absoluteString ?? "")
            selectedImagePath.text = url.absoluteString!
        }else{
            propertyManager.profileImage1 = UIImage(named: "defaultpropertyimage")
            let url: NSURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
            //print(url.absoluteString ?? "")
            selectedImagePath.text = url.absoluteString!
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func propertyBtn(_ sender: Any) {
        getProperties()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getProperties(){
        let session = URLSession.shared
        let postEndpoint: String = "https://search.onboard-apis.com/propertyapi/v1.0.0/property/snapshot?latitude=\(String(describing: address.latitude!))&longitude=\(String(describing: address.longitude!))&radius=1"
        print(postEndpoint)
        let url = URL(string: postEndpoint)!
        var request = URLRequest(url: url as URL)
        
        request.setValue("02a205de6f57ff300b669f187a7556e6", forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString!)")
            do{
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let propertys = json["property"] as? [Any] {
                     print(propertys.count)
                    // var i=0
                    for property in propertys {
                        self.apartment = Apartment()
                      // i = i+1
                        var property1 = property as? [String:Any]
                        if let identifier = property1!["identifier"] as? [String: Any] {
                            if let id : String? = String(describing: identifier["obPropId"]!){
                                print(Int64(id!)!)
                                self.apartment.apartmentId = Int64(id!)!
                            }
                            self.apartment.isRented = false
                            self.apartment.rent = Double("".randomNumericInt())
                            self.apartment.leaseSigned = false
                            if let building:[String:Any] = property1!["building"] as? [String : Any]{
                                if let size = building["size"] as? [String:Any]{
                                    self.apartment.size = String(describing:size["universalsize"])
                                }
                                if let rooms = building["rooms"] as? [String:Any]{
                                    self.apartment.numberOfBeds = Double(String(describing:rooms["beds"]!))
                                    self.apartment.numberOfBaths = Double(String(describing:rooms["bathstotal"]!))
                                    print( self.apartment.numberOfBeds!)
                                }
                            }
                            
                            if let summary:[String:Any] = property1!["summary"] as? [String:Any]{
                                self.apartment.propertyType = summary["proptype"] as? String
                            }
                            self.apartment.propertyManagerUserName = self.propertyManager.userName
                            print(property1!["address"]!)
                            if let address = property1!["address"]! as? [String:String]{
                                self.apartmentAddress.addressLine1 = address["line1"]
                                print(self.apartmentAddress.addressLine1!)
                                self.apartmentAddress.addressLine2 = ""
                                self.apartmentAddress.city = address["locality"]
                                self.apartmentAddress.country = address["country"]
                                self.apartmentAddress.postalCode = Int(address["postal1"]!)
                                self.apartmentAddress.state = address["countrySubd"]
                            }
                            if let location = property1!["location"] as? [String:Any]{
                                self.apartmentAddress.latitude = Double((location["latitude"] as? String)!)
                                self.apartmentAddress.longitude = Double((location["longitude"]as? String)!)
                            }
                            self.apartment.propertyAddress = self.apartmentAddress
                        }
                        let status = self.apartment.saveImagetoFirebase()
                        
                        OperationQueue.main.addOperation {
                               self.presentAlert()
                            self.clearTExtFields()
                        }
                    }}}catch  {
                    print("error parsing response from POST on /todos")
                    return
                }
            }
        task.resume()
    }
    
    func clearTExtFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        managementNameTextField.text = ""
        postalCodeTextField.text = ""
        stateTextField.text = ""
        cityTextField.text = ""
        addressLine1TextField.text = ""
        addressLine2TextField.text = ""
        phoneTextField.text = ""
        profileImageNameLabel.text = ""
    }
}
