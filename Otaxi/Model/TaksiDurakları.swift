//
//  Places.swift
//  Otaksi
//
//  Created by lil ero on 26.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//
import UIKit
import CoreLocation

struct TaksiDurak {
    var name: String
    var lattitude: CLLocationDegrees
    var longtitude: CLLocationDegrees
}

struct TaksiDurakları{
    static let shared = TaksiDurakları()
    let duraklar = [
        TaksiDurak(name: "Cumhuriyet Taksi" , lattitude: 40.984418 , longtitude:  37.876316),
        TaksiDurak(name: "Çicek Taksi"      , lattitude: 40.984353 , longtitude:  37.877716),
        TaksiDurak(name: "Birlik Taksi"     , lattitude: 40.981173 , longtitude:  37.883982),
        TaksiDurak(name: "Sağlam Taksi"     , lattitude: 40.980377 , longtitude:  37.884925),
        TaksiDurak(name: "Bucak Taksi"      , lattitude: 40.977695 , longtitude:  37.876756),
        TaksiDurak(name: "Sağlık Taksi"     , lattitude: 40.976927 , longtitude:  37.884538),
        TaksiDurak(name: "Yonca Taksi"      , lattitude: 40.974850 , longtitude:  37.891216),
        TaksiDurak(name: "Başak Taksi"      , lattitude: 40.973478 , longtitude:  37.892864),
        TaksiDurak(name: "Otogar Taksi"     , lattitude: 40.979743 , longtitude:  37.934225),
        TaksiDurak(name: "Meydan Taksi"     , lattitude: 40.980916 , longtitude:  37.897309),
        TaksiDurak(name: "Akyazı Taksi"     , lattitude: 40.977121 , longtitude:  37.912932)
    ]
}

