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

let DB_REF = Database.database().reference()
let USER_REF = DB_REF.child(USER_FREF)

let FS_REF = Firestore.firestore()
let USER_FSREF = FS_REF.collection(USER_FREF)

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
    func saveLocation(locationString: String, type: LocationType, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let key: String = type == .home ? "homeLocation" : "workLocation"
        USER_REF.child(uid).child(key).setValue(locationString, withCompletionBlock: completion)
    }
    func saveLocationFS(locationString: String, type: LocationType, completion: @escaping(Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let key: String = type == .home ? "homeLocation" : "workLocation"
        let value = [
            key: locationString
        ]
        USER_FSREF.document(uid).setData(value, merge: true, completion: completion)
    }
}

