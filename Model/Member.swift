//
//  Member.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/23/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation

class Member {
    var imageName: String? = nil
    var name: String? = nil
    var title: String? = nil
    var location: String? = nil
    var about: String? = nil
    var web: String? = nil
    var facebook: String? = nil
    
//    init(dictionary:NSDictionary) {
//        imageName = dictionary["image"]    as? String
//        name      = dictionary["name"]     as? String
//        title     = dictionary["title"]    as? String
//        location  = dictionary["location"] as? String
//        web       = dictionary["web"]      as? String
//        facebook  = dictionary["facebook"] as? String
//
//        // fixup the about text to add newlines
//        let unescapedAbout = dictionary["about"] as? String
//        about = unescapedAbout?.replacingOccurrences(of: "\\n", with: "\n")
//    }
//
//    class func loadMembersFromFile(path:String) -> [Member]
//    {
//        let members:[Member] = []
//
//        var error:NSError? = nil
//        if let path = Bundle.main.path(forResource: path, ofType: "sks"){
//            if let data = Data(bytesNoCopy: path, count:nil, deallocator:&error),
//                let json = JSONSerialization.JSONObjectWithData(data, options: nil, error:&error) as? NSDictionary,
//                let team = json["team"] as? [NSDictionary] {
//                for memberDictionary in team {
//                    let member = Member(dictionary: memberDictionary)
//                    members.append(member)
//                }
//            }
//        }
//        return members
//    }
}

