//
//  PropertyManager.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/13/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

extension String {
    
    ///For placeholders
    func randomAlphaNumericString(_ length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }
}

class PropertyManager: User{
    var apartmentList: [Int64]!
    var allRequests: [MaintenanceRequest]!
    var profileImage1: UIImage?
    var pathString: String?
    
    func saveToFirebase() {
        let ref: DatabaseReference?
        ref = Database.database().reference().child("users")
        ref?.child(self.userName!).setValue(["phone":self.phone as Any, "password":self.password as Any,"managementName":self.name! as String, "apartmentList":self.apartmentList, "allRequests":self.allRequests,"role":self.role!.rawValue,"profileImage":self.profileImage!])
        ref?.child(self.userName!).child("address").setValue(["addressLine1":(self.address?.addressLine1!)!, "addressLine2":(self.address?.addressLine2!)!,"city":(self.address?.city!)!,"state":(self.address?.state!)!, "postalcode":(self.address?.postalCode!)!])
    }
    
    func saveImagetoFirebase(){
        let storage = Storage.storage()
        let randomName = "".randomAlphaNumericString(8)
        let storageRef = storage.reference().child(randomName+".png")
        if self.profileImage1 == nil {
            self.profileImage1 = UIImage(named: "1")!
        }
        guard let uploadData = UIImagePNGRepresentation(self.profileImage1!)
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
                self.pathString = metadata!.downloadURL()?.absoluteString
                self.profileImage = self.pathString!
                self.saveToFirebase()
            }
        }
    }
}
