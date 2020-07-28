//
//  Service.swift
//  OrduTaxi
//
//  Created by lil ero on 20.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Firebase
import CoreLocation
import FirebaseDatabase
import GeoFire

let DB_REF = Database.database().reference()
let USER_REF = DB_REF.child(USER_FREF)
let DRIVER_LOC_FREF = DB_REF.child("driver-locations")

struct Service {
    static let shared = Service()
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        USER_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uuid = snapshot.key
            let user = User(uid: uuid, dictionary: dictionary)
            completion(user)
        }
    }
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void){
        let geoFire = GeoFire(firebaseRef: DRIVER_LOC_FREF)
        
        DRIVER_LOC_FREF.observe(.value){ (snapshot) in
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                self.fetchUserData(uid: uid) { (user) in
                    var driver = user
                    driver.location = location
                    completion(driver)
                }
            })
        }
    }
    func saveLocation(locationString: String, type: LocationType, completion: @escaping (Error?, DatabaseReference) -> Void) {
          guard let uid = Auth.auth().currentUser?.uid else { return }
          let key: String = type == .home ? "homeLocation" : "workLocation"
          USER_REF.child(uid).child(key).setValue(locationString, withCompletionBlock: completion)
      }
}
