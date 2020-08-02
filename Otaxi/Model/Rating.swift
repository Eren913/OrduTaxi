//
//  Rating.swift
//  Otaxi
//
//  Created by lil ero on 2.08.2020.
//

import UIKit
import Firebase

class Rating{
    
    private(set) var documentID: String
    private(set) var healtyScore: String
    
    init(documentID: String,healtyScore: String){
        self.documentID = documentID
        self.healtyScore = healtyScore
    }
    class func fetchRating(snapshot: QuerySnapshot?) -> [Rating]{
        var ratings = [Rating]()
        guard let snap = snapshot else { return ratings }
        for kayit in snap.documents {
            let veri = kayit.data()
            let healtyScore = veri[HEALTH_SCORE_FREF] as? String ?? ""
            let documentId = kayit.documentID
            let yeniBegeni = Rating(documentID: documentId, healtyScore: healtyScore)
            ratings.append(yeniBegeni)
        }
        return ratings
    }
}
