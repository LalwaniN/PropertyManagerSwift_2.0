//
//  PMChatUserListViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/28/18.
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

class PMChatUserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var propManagerUserName = ""
    var sourceEmail : String?
    var userList:[String]? = []
    var messagesList: [MessageQueue] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var destinationUserName: String?
    var destinationEmail: String?
    var index: Int?
    var selecteduserName: String?
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableViewAutomaticDimension
        print(userList!)
        findMessagesList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToPropertyManagerHome" {
            let controller = segue.destination as! PropertyManagerHomeViewController
            controller.propManagerUserName = self.propManagerUserName
        }
        if segue.identifier == "pmChatLogSegue" {
            let controller = segue.destination as! PMChatLogViewController
            controller.propManagerUserName = self.propManagerUserName
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messagesList.count)
        return messagesList.count
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
        
        if(!messagesList.isEmpty){
            let curruser = messagesList[indexPath.row].toId
            print(curruser!)
            var timestampcorrect: String = ""
            tableView.estimatedRowHeight = 72
            cell?.nameLabel.text = curruser
            cell?.subtitleLabel?.text = messagesList[indexPath.row].text
            if let timestamp = messagesList[indexPath.row].timestamp{
                if let seconds:Double = Double(timestamp) {
                    let timestampDate = NSDate(timeIntervalSince1970: seconds)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm:ss a"
                    let finalDateString = dateFormatter.string(from: timestampDate as Date)
                    timestampcorrect = finalDateString
                    print(timestampcorrect)
                }
            }
            cell?.timestampLabelCell.text = timestampcorrect
        }
        return cell!
    }
    
    func findMessagesList(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if(!snapshot.hasChildren()){
                print("No chats available!")
            }
            let value = snapshot.value as? [String:Any]
            if((value!["toId"] as? String == self.sourceEmail! || value!["fromId"] as? String == self.sourceEmail!)){
                let message = MessageQueue()
                message.fromId = value!["fromId"]! as? String
                message.toId = value!["toId"]! as? String
                message.text = value!["text"]! as? String
                message.timestamp = value!["timestamp"]! as? NSNumber
                self.messagesList.append(message)
            }
            self.messagesList.sort(by: { (m1,m2) -> Bool in
                return m1.timestamp?.intValue < m2.timestamp?.intValue
            })
            //self.tableView.reloadData()
        })
    }
}
