//
//  ReportedIssuesForPropManagerViewController.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/28/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import Firebase

class ReportedIssuesForPropManagerViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var ref: DatabaseReference?
    var sections : [String] = ["PENDING REQUESTS","COMPLETED REQUESTS"]
    var pendingRequests : [MaintenanceRequest]?
    var completedRequests : [MaintenanceRequest]?
    var propManagerUserName = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        //print(completedRequests?.count)
        //print(pendingRequests?.count)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        self.hideKeyboardWhenTappedAround()
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "bcgd3")?.alpha(0.7)
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        pendingRequests = []
        completedRequests = []
        populateRequestsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
  
    func populateRequestsList(){
        pendingRequests = []
        completedRequests = []
        print(self.propManagerUserName)
        var request : MaintenanceRequest?
        ref = Database.database().reference().child("issues")
        ref?.queryOrdered(byChild: "propertyManagerUserName").queryEqual(toValue: (self.propManagerUserName)).observe(.childAdded, with: { (snapshot) in
            
            if(!snapshot.hasChildren()){
                print("No requests raised!")
            }
            let values = snapshot.value as? NSDictionary
            print("--------------")
            print(values!)
            request = MaintenanceRequest()
//            print(values!["requestType"]!)
//            print(Int64(values!["apartmentId"] as! Int64))
//
//            print(values!["requestType"]!)
//            print(values!["requestType"]!)
//            print((values!["status"] as? String!)!)
//            print((values!["requestDescription"] as? String!)!)
            request?.requestType = values!["requestType"] as? String
            request?.apartmentId = Int64(values!["apartmentId"] as! Int64)
            request?.status = values!["status"] as? String
            request?.requestDescription = values!["requestDescription"] as? String
            request?.requestId = snapshot.key
            request?.requestImagePath = values!["requestImagePath"] as? String
            request?.propertyManagerUserName = values!["propertyManagerUserName"] as? String
            if(request?.status == "Pending"){
                self.pendingRequests?.append(request!)
            }else{
                self.completedRequests?.append(request!)
            }
            self.tableView.reloadData()
            
        })

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (section == 0) {
            return pendingRequests!.count
        }
        else{
            return completedRequests!.count
        }
        
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        var request : MaintenanceRequest?
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath)
        if (indexPath.section == 0) {
            request = pendingRequests![indexPath.row]
            //print(request!)
        }
        else{
            request = completedRequests![indexPath.row]
        }

        cell.textLabel!.text = (String(describing: request!.apartmentId!))
        var image : UIImage?
        if request!.requestType == "Pest Control"{
            image = UIImage(named: "pestControl")!
        }else if request!.requestType == "Appliance Repair"{
            image = UIImage(named: "applianceRepair")!
        }else if request!.requestType == "Plumbing"{
            image = UIImage(named: "plumber")!
        }else if request!.requestType == "Carpet Cleaning"{
            image = UIImage(named: "carpetCleaning")!
        }
        else if request!.requestType == "Noise Issue"{
           image =  UIImage(named: "noise")!
        }
        cell.imageView!.image = image
        cell.imageView?.contentMode = .scaleAspectFill
        cell.detailTextLabel?.text = request!.requestDescription
        return cell
        }

   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0){
             return true
        }
        else {
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // 1
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Mark as Complete!" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
           // print("hi")
            //let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath)
            
            var request = self.pendingRequests![indexPath.row]
            request.status = "Complete"
            
            self.ref?.child(request.requestId!).setValue(["requestType":request.requestType!, "requestDescription":request.requestDescription!,"requestImagePath":request.requestImagePath! , "apartmentId":request.apartmentId!, "status":request.status!, "propertyManagerUserName":request.propertyManagerUserName!])
            self.pendingRequests = []
            self.completedRequests = []
            self.populateRequestsList()
            tableView.reloadData()
        })

        return [shareAction]
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       if segue.identifier == "backToPropertymanagerHome" {
            let controller = segue.destination as! PropertyManagerHomeViewController
            controller.propManagerUserName  = self.propManagerUserName
        }
    }

}
