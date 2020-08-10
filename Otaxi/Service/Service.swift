//
//  Service.swift
//  OrduTaxi
//
//  Created by lil ero on 20.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
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
    func getProfilePhotoFS(uid: String, imageView: UIImageView){
        var profilPhoto = [ProfilPhoto]()
        let db = Firestore.firestore().collection(USER_FREF)
        let ref = db.document(uid).collection(PROFILEPHOTO_REF)
        ref.addSnapshotListener { (snapshot, error) in
            if snapshot?.isEmpty == false && snapshot != nil {
                profilPhoto = ProfilPhoto.fetchProfilephoto(snapshot: snapshot)
                for photo in profilPhoto{
                    imageView.sd_setImage(with: URL(string: photo.imageUrl))
                    break
                }
            }else{
                imageView.image =  nil
            }
        }
        
    }
    
    func fetchRating(selectedDriveruid uid: String,completion: @escaping(Int) -> Void){
        var bgn = [Begeni]()
        guard let uide = Auth.auth().currentUser?.uid else {return}
        let begeniSorgu = USER_FSREF.document(uid).collection(BEGENI_FSREF).whereField(USER_ID_FREF, isEqualTo: uide)
        begeniSorgu.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {print("DEBUG: Error fetching document: \(error!)")
                return}
            bgn = Begeni.BegenileriGetir(snapshot: document)
            for begeniler in bgn{
                completion(begeniler.likeCount)
            }
        }
    }
    
    
    func setFavoriteTaxiData(fullname: String,selectedDriverUid: String,Delete: Bool,completion: @escaping(Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let way = USER_FSREF.document(uid).collection(FAVORITES_TAXI_FSREF).document(selectedDriverUid)
        if Delete == true{
            way.delete { (err) in
                if let err = err {
                    print("DEBUG: error favortie taxi deleting \(err.localizedDescription)")
                }
            }
        }else{
            way.setData([
                FULLNAME_FREF : fullname,
                USER_ID_FREF  : selectedDriverUid]) { (error) in
                    if let error = error {
                        completion(error)
                    }
            }
        }
        
    }
    
}

