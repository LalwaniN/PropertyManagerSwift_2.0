//
//  User.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/8/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User{
    var phone: Int64?
    var address: Address?
    var userName: String?
    var password: String?
    var name: String?
    var profileImage: String?
    var role:Role?
}

enum Role:String {
    case Tenant
    case Owner
    case PropertyManager
}


