//
//  ChatLogViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/26/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import Firebase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class ChatLogViewController: UIViewController,UITableViewDelegate,UITextFieldDelegate {
    var apartmentId:Int64?
    var userList:[String]?
    var destinationUserName: String?
    var destinationEmail: String?
    var sourceEmail:String?
    
    
    var messages: [MessageQueue] = []
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var navBatTitle: UINavigationItem!
    @IBOutlet weak var lowestView: UIView!
    @IBOutlet var bottomHeight1: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    //Actions
    @IBAction func sendBtnAction(_ sender: UIButton) {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        print(destinationEmail!)
        print(sourceEmail!)
        print(timestamp)
        let values = ["text": messageTextField.text!, "toId":destinationEmail!, "fromId":sourceEmail!, "timestamp":timestamp] as [String : Any]
        childRef.updateChildValues(values)
        messageTextField.text = ""
    }
    
    func handleEnter(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        print(destinationEmail!)
        print(sourceEmail!)
        print(timestamp)
        let values = ["text": messageTextField.text!, "toId":destinationEmail!, "fromId":sourceEmail!, "timestamp":timestamp] as [String : Any]
        childRef.updateChildValues(values)
        messageTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        findMessagesList()
        // Do any additional setup after loading the view.
        messageTextField.delegate = self
        navBatTitle.title = destinationUserName!
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func findMessagesList(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if(!snapshot.hasChildren()){
                print("No chats available!")
            }
            let value = snapshot.value as? [String:Any]
            if((value!["toId"] as? String == self.sourceEmail! && value!["fromId"] as? String == self.destinationEmail!) || (value!["toId"] as? String == self.destinationEmail! && value!["fromId"] as? String == self.sourceEmail!)){
                let message = MessageQueue()
                message.fromId = value!["fromId"]! as? String
                message.toId = value!["toId"]! as? String
                message.text = value!["text"]! as? String
                message.timestamp = value!["timestamp"]! as? NSNumber
                self.messages.append(message)
            }
            self.messages.sort(by: { (m1,m2) -> Bool in
                return m1.timestamp?.intValue < m2.timestamp?.intValue
            })
            self.tableView.reloadData()
            print(1)
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleEnter()
        return true
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        print(keyboardHeight)
        print(bottomHeight1.constant)
        self.bottomHeight1?.constant = keyboardHeight
        self.view.layoutIfNeeded()
    }
        
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        bottomHeight1.constant = 0.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chatScreenBackToListSegue" {
            let controller = segue.destination as! ChatUserListControllerViewController
            controller.userList = self.userList!
            controller.destinationUserName = self.destinationUserName
            controller.destinationEmail = self.destinationEmail
            controller.sourceEmail = self.sourceEmail!
            controller.apartmentId = self.apartmentId!
        }
    }
}

extension ChatLogViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as! ChatScreenTableViewCell
        print(indexPath.row)
        let message = messages[indexPath.row]
        var latestTimeStamp:String = ""
        print(message.text!)
        if let timestamp = message.timestamp{
            if let seconds:Double = Double(timestamp) {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                let finalDateString = dateFormatter.string(from: timestampDate as Date)
                latestTimeStamp = finalDateString
                print(latestTimeStamp)
            }
        }
        tableView.rowHeight = 50
        if(message.toId == destinationEmail){
            cell.messageLabel.textAlignment = NSTextAlignment.left
            cell.messageLabel.text = message.text
            cell.timeStampLabel.text = latestTimeStamp
        }else{
            cell.messageLabel.textAlignment = NSTextAlignment.right
            cell.messageLabel.text = message.text
            cell.timeStampLabel.text = latestTimeStamp
        }
        
        return cell
    }
}
