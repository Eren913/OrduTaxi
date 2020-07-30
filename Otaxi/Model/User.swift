//
//  User.swift
//  OrduTaxi
//
//  Created by lil ero on 20.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//
import CoreLocation
import FirebaseDatabase

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
    
    func fetchAlldata(completion: @escaping([User]) -> Void){
        USER_REF.observeSingleEvent(of: .value) { (snapshot) in
            var users = [User]()
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            for child in dictionary {
                let user = User(uid: child.key, dictionary: child.value as! [String : Any])
                users.append(user)
                completion(users)
            }
        }
    }
}

