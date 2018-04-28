//
//  MaintenanceRequest.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/8/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class MaintenanceRequest {
    var requestId : String?
    var requestType : String?
    var requestDescription : String?
    var requestImagePath : String?
    var requestImage : UIImage?
    var apartmentId : Int64?
    var status: String?
    var apartmentLine1 : String?
    var propertyManagerUserName : String?
    
    func saveToFirebase() {
        var ref = Database.database().reference().child("issues")
        let childRef = ref.childByAutoId()
        self.status = "Pending"
        print(self.requestType!)
        print(self.requestDescription!)
        print(self.requestImagePath!)
        print(self.apartmentId!)
       // print(self.requestType!)
        print(self.status!)
        childRef.setValue(["requestType":self.requestType!, "requestDescription":self.requestDescription!,"requestImagePath":self.requestImagePath! , "apartmentId":self.apartmentId!, "status":self.status!, "propertyManagerUserName":self.propertyManagerUserName!])
       
    }
    
    func saveImagetoFirebase(){
        let storage = Storage.storage()
        let randomName = "".randomAlphaNumericString(8)
        let storageRef = storage.reference().child(randomName+".png")
        if self.requestImage == nil {
            self.requestImage = UIImage(named: "1")!
        }
        guard let uploadData = UIImagePNGRepresentation(self.requestImage!)
            else{
                return
        }
        storageRef.putData(uploadData,metadata: nil) {
            metadata,error in
            
            if(error != nil){
                print(error!)
                return
            }else{
                print(metadata!.downloadURL()?.absoluteString)
                var pathString = metadata!.downloadURL()?.absoluteString
                self.requestImagePath = pathString!
                self.saveToFirebase()
            }
        }
    }
}
