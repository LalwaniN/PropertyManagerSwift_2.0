//
//  LoginViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/10/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    var role = ""
    var userLoggedIn = ""
    var apartmentId:Int64?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let blueColor : UIColor = UIColor( red: 68.0/255, green: 126.0/255, blue:194.0/255, alpha: 1.0 )
        
        //Implementing Layers,Border Color & Width
        usernameTextField.layer.borderColor = blueColor.cgColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 15
        
        passwordTextField.layer.borderColor = blueColor.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 15
        
        loginButton.layer.cornerRadius = 15
        
        //Setting Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "od2")?.alpha(0.4)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        loginLabel.center.y -= view.bounds.width
        usernameTextField.center.x -= view.bounds.width
        passwordTextField.center.x += view.bounds.width
        loginButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //usernameTextField.center.x = self.view.center.x
        //passwordTextField.center.x = self.view.center.x
        loginLabel.center.x = self.view.center.x
        loginButton.center.x = self.view.center.x
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0, animations: {
            self.loginLabel.center.y += self.view.bounds.width
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 1.5, delay: 0.5,
                                   usingSpringWithDamping: 0.3,
                                   initialSpringVelocity: 0.5,
                                   options: [], animations: {
                                    self.usernameTextField.center.x += self.view.bounds.width
                                    self.passwordTextField.center.x -= self.view.bounds.width
                                    if(self.usernameTextField.center.x != self.view.center.x){
                                        self.usernameTextField.center.x = self.view.center.x
                                    }
                                    if(self.passwordTextField.center.x != self.view.center.x){
                                        self.passwordTextField.center.x = self.view.center.x
                                    }
                                    self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 2.0,
                                   options: [],
                                   animations: {
                                    self.loginButton.alpha = 1.0
        }, completion: nil)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        var userName : String = usernameTextField.text!
        let password : String = passwordTextField.text!
        
//        if(!isValidEmail(testStr: userName)){
//            self.usernameTextField.shake()
//            return
//        }
        
        
        userName = userName.replacingOccurrences(of: ".", with: ",")
        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        var flag: Bool = true
        ref?.child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(!snapshot.hasChildren()){
                self.usernameTextField.shake()
                self.passwordTextField.shake()
                return
            }
            
            let userpassword = value?["password"] as? String
            let userrole = value?["role"] as? String

            if(userpassword == nil){
                flag = false
            }else{
                
                if(password==userpassword!){
                     self.userLoggedIn = userName
                    if(userrole!=="PropertyManager"){
                        self.role = "PropertyManager"
                        self.performSegue(withIdentifier: "propertyLoginSegue", sender: self)
                    }else if(userrole!=="Tenant"){
                        self.role = "Tenant"
                        self.apartmentId = value?["apartmentId"] as? Int64
                         self.performSegue(withIdentifier: "tenantLoginSegue", sender: self)
                    }else if(userrole!=="Owner"){
                        flag = false;
                    }else{
                        flag = false;
                    }
                }else{
                     flag = false;
                    self.usernameTextField.shake()
                    self.passwordTextField.shake()
                    return
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            flag = false;
            self.usernameTextField.shake()
            self.passwordTextField.shake()
            return
        }

        if(!flag){
            usernameTextField.shake()
            passwordTextField.shake()
            return
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "propertyLoginSegue" {
            let controller = segue.destination as! PropertyManagerHomeViewController
                controller.propManagerUserName = self.userLoggedIn
        }else if segue.identifier == "tenantLoginSegue"  {
              let controller = segue.destination as! TenantHomeViewController
              controller.tenantUserName = self.userLoggedIn
              controller.apartmentId = self.apartmentId!
            }
    }
}

extension UITextField {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

