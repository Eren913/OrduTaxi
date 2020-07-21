//
//  DriverAnnotation.swift
//  Otaxi
//
//  Created by lil ero on 21.07.2020.
//

import MapKit

class DriverAnnotation: NSObject,   MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var uid : String
    
    init(uid : String,coordinate : CLLocationCoordinate2D){
        self.uid = uid
        self.coordinate = coordinate
    }
}
