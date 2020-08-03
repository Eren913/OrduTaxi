//
//  User.swift
//  OrduTaxi
//
//  Created by lil ero on 20.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//
import CoreLocation
import FirebaseDatabase
import FirebaseFirestore

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    let fullname: String
    let email: String
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
    var homeLocation: String?
    var workLocation: String?
    
    var firstInitial: String { return String(fullname.prefix(1)) }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary[FULLNAME_FREF] as? String ?? ""
        self.email = dictionary[EMAİL_FREF] as? String ?? ""
        
        if let home = dictionary["homeLocation"] as? String {
            self.homeLocation = home
        }
        
        if let work = dictionary["workLocation"] as? String {
            self.workLocation = work
        }
        
        if let index = dictionary[ACCOUNT_TYPE_FREF] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
struct Drivers{
    let uid: String?
    let fullname: String?
    let email: String?
    var healthpoint: Double?
    let stop: String?
    var accountType: AccountType?
    var firstInitial: String { return String((fullname?.prefix(1))!) }
}


