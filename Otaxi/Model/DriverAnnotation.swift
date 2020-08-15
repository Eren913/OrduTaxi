//
//  DriverAnnotation.swift
//  Otaxi
//
//  Created by lil ero on 21.07.2020.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation{
    
    dynamic var coordinate: CLLocationCoordinate2D
    var uid : String
    
    init(uid : String,coordinate : CLLocationCoordinate2D){
        self.uid = uid
        self.coordinate = coordinate
    }
    func updateAnnotationLocations(withLocations coordinate: CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var telNo: String?
    var adress: String?
    
    init(title:String?,subtitle: String?,coordinate: CLLocationCoordinate2D?,telNo: String?,adress: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        self.telNo = telNo
        self.adress = adress
        super.init()
    }
}

