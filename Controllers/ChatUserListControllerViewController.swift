//
//  ChatUserListControllerViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/26/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatUserListControllerViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    var messagesList: [MessageQueue] = []
    var messagesSentTo: [String] = []
    var userList:[String]?
    var apartmentId:Int64?
    var destinationUserName: String?
    var destinationEmail: String?
    var sourceEmail: String?
    var index: Int?
    var messagedict : [String:[String]] = [:]
    var keyList : [String] = []
    
    var latestTimeStamp: String?
    var latestMessage: String?
    var selecteduserName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableViewAutomaticDimension
        self.hideKeyboardWhenTappedAround()
        observeMessages()
        getMessagePerUser()
        print(apartmentId!)
    }

    
    func getMessagePerUser(){
        let ref: DatabaseReference =  Database.database().reference()
        
        ref.child("messages").queryOrdered(byChild: "fromId").queryEqual(toValue: self.sourceEmail!).observe(.childAdded, with: { snaphot in
            // Get user value
            let value = snaphot.value as? NSDictionary
            
            if(!snaphot.hasChildren()){
                print("Error getting user!")
                return
            }
            
            print("VALUE")
            print(value!)
            print(value!["toId"]!)
            self.messagesSentTo.append((value!["toId"]! as? String)!)
            
            for receipient in self.messagesSentTo{
                print(receipient)
                ref.child("messages").queryOrdered(byChild: "toId").queryEqual(toValue: receipient).observe(.childAdded, with: { snaphot in
                    // Get user value
                    let value = snaphot.value as? NSDictionary
                    
                    if(!snaphot.hasChildren()){
                        print("Error getting user!")
                        return
                    }
                    
                    if let timestamp = value!["timestamp"] as? NSNumber{
                        if let seconds:Double = Double(timestamp) {
                            let timestampDate = NSDate(timeIntervalSince1970: seconds)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "hh:mm:ss a"
                            var finalDateString = dateFormatter.string(from: timestampDate as Date)
                            self.latestTimeStamp = finalDateString
                            print(self.latestTimeStamp!)
                        }
                    }
                    
                    print(receipient)
                    var message = value!["text"] as? String
                    self.messagedict[receipient] = [message!,self.latestTimeStamp!]
                })
                if(receipient == self.messagesSentTo.last){
                    self.updateTableData()
                }
            }
        })
    }
    
    func updateTableData(){
        print("----INSIDE----")
        for user in userList!{
            if messagedict[user] == nil {
                messagedict[user] = ["",""]
            }
        }
        
        for message in messagedict{
            keyList.append(message.key)
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userList!.count)
        return userList!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        index = indexPath.row
        selecteduserName = userList?[(indexPath.row)]
        let ref: DatabaseReference =  Database.database().reference()
        
        ref.child("users").child(selecteduserName!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(!snapshot.hasChildren()){
                print("Error getting user!")
                return
            }
        
            let role = value!["role"] as! String
            if role == "PropertyManager"{
                let name = value?["managementName"] as! String
                self.destinationEmail = self.userList?[self.index!]
                self.destinationUserName = value?["managementName"] as? String
                self.performSegue(withIdentifier: "chatScreenSegue", sender: self)
            }else{
                let first = value?["firstName"] as! String
                let last = value?["lastName"] as! String
                self.destinationEmail = self.userList?[self.index!]
                self.destinationUserName = first + last
                self.performSegue(withIdentifier: "chatScreenSegue", sender: self)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as? UserTableCell
        
        if(!keyList.isEmpty){
            var curruser = keyList[indexPath.row]
            print(curruser)
            
            var currmsg = messagedict[curruser]
            cell?.nameLabel.text = curruser
            var i=0;
            for curr in currmsg!{
                print(curr)
                if(i==0){
                    cell?.subtitleLabel?.text = curr
                    i = i+1;
                }else{
                   cell?.timestampLabelCell.text = curr
                }
            }
        }
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chatScreenSegue" {
            let controller = segue.destination as! ChatLogViewController
            controller.userList = userList
            controller.destinationUserName = destinationUserName!
            controller.destinationEmail = destinationEmail!
            controller.sourceEmail = sourceEmail!
            controller.apartmentId = self.apartmentId!
        }
        if segue.identifier == "chatListToTenantHomeSegue" {
            let controller = segue.destination as! TenantHomeViewController
            controller.apartmentId = self.apartmentId!
        }
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject]{
                let message = MessageQueue()
                //self.messagesKey.append(snapshot.key)
                message.fromId = dict["fromId"]! as? String
                message.text = dict["text"]! as? String
                message.toId = dict["toId"]! as? String
                message.timestamp = dict["timestamp"]! as? NSNumber
                self.messagesList.append(message)
            }
        }, withCancel: nil)
    }
}
