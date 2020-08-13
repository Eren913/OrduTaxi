//
//  Rating.swift
//  Otaxi
//
//  Created by lil ero on 2.08.2020.
//

import UIKit
import Firebase
//MARK:-Rating
class Rating{
    private(set) var uid: String
    private(set) var fullname: String
    private(set) var email: String
    private(set) var healthpoint: Double
    private(set) var stop: String
    private(set) var accountType: Int
    private(set) var telNo: String
    private(set) var useruid: String?
    private(set) var plaka: String?
    var firstInitial: String { return String((fullname.prefix(1))) }
    init(uid: String,fullname: String,email: String,healthpoint: Double,stop: String,accountType: Int,firstInitial: String? = nil,telNo: String,useruid: String?,plaka: String?){
        self.uid = uid
        self.fullname = fullname
        self.email = email
        self.healthpoint = healthpoint
        self.stop = stop
        self.accountType = accountType
        self.telNo = telNo
        self.useruid = useruid
        self.plaka = plaka
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
            let userIDfsref = document.get(USER_ID_FREF) as? String ?? "useridFref"
            let accoubtType = document.get(ACCOUNT_TYPE_FREF) as? Int ?? 0
            let plaka = document.get(PLAKA_FREF) as? String ?? "Plaka Yok"
            let uid = document.documentID
            let driverInfo = Rating(uid: uid, fullname: username, email: email, healthpoint: healt, stop: stop, accountType: accoubtType, firstInitial: nil, telNo: tel, useruid: userIDfsref, plaka: plaka)
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
//MARK:-Begeni
class Begeni{
    
    private(set) var kullaniciId : String
    private(set) var documentId : String
    private(set) var likeCount : Int
    
    init(kullanici_like_id: String ,kullanici_doc_id :String,likeCount : Int){
        self.kullaniciId = kullanici_like_id
        self.documentId = kullanici_doc_id
        self.likeCount = likeCount
    }
    class func BegenileriGetir(snapshot: QuerySnapshot?) -> [Begeni]{
        var begeniler = [Begeni]()
        guard let snap = snapshot else { return begeniler }
        for kayit in snap.documents {
            let veri = kayit.data()
            let kullaniciId = veri[USER_ID_FREF] as? String ?? ""
            let likecount = veri[LIKECOUNT] as? Int ?? 0
            let documentId = kayit.documentID
            let yeniBegeni = Begeni(kullanici_like_id: kullaniciId, kullanici_doc_id: documentId, likeCount: likecount)
            begeniler.append(yeniBegeni)
        }
        return begeniler
    }
}
//MARK:-Favorites
class Favorites{
    private(set) var userID: String
    init(userID: String) {
        self.userID = userID
    }
    class func fetchFavorites(QuerySnapshot snapshot: QuerySnapshot?) -> [Favorites]{
        var fav = [Favorites]()
        guard let snap = snapshot else {return fav}
        for doc in snap.documents{
            let userId = doc[USER_ID_FREF] as? String ?? ""
            let favs = Favorites(userID: userId)
            fav.append(favs)
        }
        return fav
    }
}

struct CarPhotoM{
    //kullanıcı bilgilerinin saklaınıdığı yer
    var kullaniciID : String
    var goruntuURL1 : String?
    var goruntuURL2 : String?
    var goruntuURL3 : String?
    //İnit olusuturup kullanıcı
    init(bilgiler : [String : Any]){
        self.goruntuURL1 = bilgiler["Goruntu_URL"] as? String
        self.goruntuURL2 = bilgiler["Goruntu_URL2"] as? String
        self.goruntuURL3 = bilgiler["Goruntu_URL3"] as? String
        self.kullaniciID = bilgiler[USER_ID_FREF] as? String ?? ""
    }
}
