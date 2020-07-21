//
//  User.swift
//  OrduTaxi
//
//  Created by lil ero on 20.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

struct User {
    
    let fullname : String
    let email  : String
    let accountType : Int
    
    init(dictinoary : [String : Any]) {
        self.fullname = dictinoary[FULLNAME_FREF] as? String ?? ""
        self.email = dictinoary[EMAİL_FREF] as? String ?? ""
        self.accountType = dictinoary[ACCOUNT_TYPE_FREF] as? Int ?? 0
    }
}

