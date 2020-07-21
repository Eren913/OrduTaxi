//
//  User.swift
//  OrduTaxi
//
//  Created by lil ero on 20.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//
import CoreLocation
struct User {
    
    let fullname : String
    let email  : String
    let accountType : Int
    var location : CLLocation?
    let uid : String
    
    init(uid: String,dictinoary : [String : Any]) {
        self.uid = uid
        self.fullname = dictinoary[FULLNAME_FREF] as? String ?? ""
        self.email = dictinoary[EMAİL_FREF] as? String ?? ""
        self.accountType = dictinoary[ACCOUNT_TYPE_FREF] as? Int ?? 0
    }
}

