//
//  Apartment.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/9/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation
import Firebase

class Apartment{
    var apartmentId : Int64?
    var isRented : Bool?
    var numberOfBeds : Double?
    var numberOfBaths : Double?
    var propertyCost : Double?
    var propertyType : String?
    var rent: Double?
    var propertyAddress : Address?  = Address()
    var tenantList : [String] = []
    var leaseStartDate: Date?
    var leaseEndDat : Date?
    var rentPayments : [Payment]?
    var rentDueDate  : Date?
    var leaseDocuments : [Document]?
    var leaseSigned: Bool?
    var amenites: String?
    var propertyManagerUserName : String?
    var size:String?
    var apartmentImages:[String]? = []
    
    func saveToFirebase() -> Bool {
        let ref: DatabaseReference?
        ref = Database.database().reference().child("apartments")
        
        let aid = String(describing: self.apartmentId!)
        let rentedis = String(describing: self.isRented!)
        let beds = self.numberOfBeds
        let baths = self.numberOfBaths
        //let lsigned = (String(describing: self.leaseSigned!))
        let rent = self.rent
        print(beds!)
        print(baths!)
        print(self.apartmentImages!)
        ref?.child(aid).setValue(["isRented":rentedis,"numberOfBeds":beds!, "numberOfBaths":baths!, "propertyType":self.propertyType!, "propertyManagerUserName":self.propertyManagerUserName!,"rent":rent!,"apartmentImages":self.apartmentImages!,"tenantList":self.tenantList])
        print((self.propertyAddress?.addressLine1)!)
        print((self.propertyAddress?.addressLine2)!)
            print((self.propertyAddress?.state)!)
            print((self.propertyAddress?.city)!)
            print((self.propertyAddress?.postalCode)!)
            print((self.propertyAddress?.country)!)
            print((self.propertyAddress?.longitude)!)
            print((self.propertyAddress?.latitude)!)
        ref?.child(aid).child("address").setValue(["addressLine1":(self.propertyAddress?.addressLine1)!, "addressLine2":(self.propertyAddress?.addressLine2)!, "state": (self.propertyAddress?.state)!, "city":(self.propertyAddress?.city)!, "postalcode": (self.propertyAddress?.postalCode)!, "country": (self.propertyAddress?.country)!, "latitude": (self.propertyAddress?.latitude)!, "longitude":(self.propertyAddress?.longitude)!])
        i = i + 1
        print("----------i-------------------")
        print(i)
        return true
        
    }
    
    func saveImagetoFirebase() -> Bool{
        if(i>4){
            return true
        }
        let storage = Storage.storage()
       var status = false;
        self.apartmentImages = []
        for _ in 1...3 {
            status = false;
            let random = arc4random_uniform(83) + 10;
            print(random)
            let image = UIImage(named: String(random))
            let randomName = "".randomAlphaNumericString(8)
            let storageRef = storage.reference().child(randomName+".png")
            
        guard let uploadData = UIImagePNGRepresentation(image!)
            else{
                return false
        }
        storageRef.putData(uploadData,metadata: nil) {
            metadata,error in
           
            if(error != nil){
                print(error!)
                status = false
            }else{
                print(metadata!.downloadURL()?.absoluteString)
                var pathString = metadata!.downloadURL()?.absoluteString
                self.apartmentImages?.append(pathString!)
                status =  self.saveToFirebase()

            }
        }
        }
        return status
    }
}
