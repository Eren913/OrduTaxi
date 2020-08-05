//
//  Rating.swift
//  Otaxi
//
//  Created by lil ero on 2.08.2020.
//

import UIKit
import Firebase

class Rating{
    private(set) var uid: String
    private(set) var fullname: String
    private(set) var email: String
    private(set) var healthpoint: Double
    private(set) var stop: String
    private(set) var accountType: Int
    private(set) var telNo: String
    var firstInitial: String { return String((fullname.prefix(1))) }
    init(uid: String,fullname: String,email: String,healthpoint: Double,stop: String,accountType: Int,firstInitial: String? = nil,telNo: String){
        self.uid = uid
        self.fullname = fullname
        self.email = email
        self.healthpoint = healthpoint
        self.stop = stop
        self.accountType = accountType
        self.telNo = telNo
    }
    class func fetchRating(snapshot: QuerySnapshot?) -> [Rating]{
        var ratings = [Rating]()
        guard let snap = snapshot else { return ratings }
        for document in snap.documents{
            let healt = document.get(HEALTH_SCORE_FREF) as? Double ?? 0.00
            let username = document.get(FULLNAME_FREF) as? String ?? "Misafir"
            let email = document.get(EMAİL_FREF) as? String ?? "deneme@deneme.com"
            let stop = document.get(DURAK_ISMI_FREF) as? String ?? "Durak yok"
            let tel = document.get(TEL_NO_FREF) as? String ?? "Tel No yok"
            let accoubtType = document.get(ACCOUNT_TYPE_FREF) as? Int ?? 0
            let uid = document.documentID
            let driverInfo = Rating(uid: uid, fullname: username, email: email, healthpoint: healt, stop: stop, accountType: accoubtType, firstInitial: nil, telNo: tel)
            ratings.append(driverInfo)
        }
        return ratings
    }
}
class ProfilPhoto{
    private(set) var uid: String
    private(set) var imageUrl: String
    
    init(uid: String,imageUrl: String) {
        self.uid = uid
        self.imageUrl = imageUrl
    }
    class func fetchProfilephoto(snapshot: QuerySnapshot?) -> [ProfilPhoto]{
        var pp = [ProfilPhoto]()
        guard let snap = snapshot else { return pp }
        for document in snap.documents{
            let uid = document.documentID
            let imageUrlArray = document.get(IMAGEURL_REF_FS) as? String ?? ""
            let driverInfo = ProfilPhoto(uid: uid, imageUrl: imageUrlArray)
            pp.append(driverInfo)
        }
        return pp
    }
    
}
