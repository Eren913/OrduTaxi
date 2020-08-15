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
    var telNo: String
    var adress: String
}

struct TaksiDurakları{
    static let shared = TaksiDurakları()
    let duraklar = [
        TaksiDurak(name: "Güneş Taksi"      , lattitude: 40.967282 , longtitude:  37.896216, telNo:"(0452) 888 61 11", adress: "Şahincili, 578. Sk. No:4, Altınordu/Ordu"),
        TaksiDurak(name: "Karşıyaka Taksi"  , lattitude: 40.970124 , longtitude:  37.913271, telNo:"(0452) 777 11 22", adress: "Karşıyaka, 1053. Sk. no:2, Altınordu/Ordu"),
        TaksiDurak(name: "Şahincili Taksi"  , lattitude: 40.966210 , longtitude:  37.888493, telNo:"(0452) 888 63 63", adress: "Şahincili, 588. Sk., Altınordu/Ordu"),
        TaksiDurak(name: "Şirin Taksi"      , lattitude: 40.966160 , longtitude:  37.903574, telNo:"(0452) 777 46 66", adress: "Şirinevler, 725. Sk. No:2/1, Altınordu/Ordu"),
        TaksiDurak(name: "Ordu Taksi"       , lattitude: 40.977061 , longtitude:  37.885101, telNo:"0537 062 67 27"  , adress: "Subaşı, 476. Sk. No:4, Altınordu/Ordu"),
        TaksiDurak(name: "Fidangör Taksi"   , lattitude: 40.986911 , longtitude:  37.874711, telNo:"(0452) 214 08 17", adress: "Düz, Gören Sk., Altınordu/Ordu"),
        TaksiDurak(name: "Güzel Ordu Taksi" , lattitude: 40.981577 , longtitude:  37.881121, telNo:"(0452) 225 15 55", adress: "Şarkiye, Cumhuriyet Cd. No:40, Altınordu/Ordu"),
        TaksiDurak(name: "Meydan Taksi"     , lattitude: 40.981221 , longtitude:  37.897375, telNo:"(0452) 234 48 79", adress: "Bahçelievler, Erol Ataşan Blv. No:19, Altınordu/Ordu"),
        TaksiDurak(name: "Huzur Taksi"      , lattitude: 40.978839 , longtitude:  37.891070, telNo:"(0452) 234 47 66", adress: "Yeni, Kahraman Sağra Cd. No:54, Altınordu/Ordu"),
        TaksiDurak(name: "Cumhuriyet Taksi" , lattitude: 40.984418 , longtitude:  37.876316, telNo:"(0452) 214 17 79", adress: "Selimiye, Hükümet Cd. No:61, Altınordu/Ordu"),
        TaksiDurak(name: "Çicek Taksi"      , lattitude: 40.984353 , longtitude:  37.877716, telNo:"(0452) 225 14 19", adress: "Selimiye, Lise Cd. No:15, Altınordu/Ordu"),
        TaksiDurak(name: "Birlik Taksi"     , lattitude: 40.981173 , longtitude:  37.883982, telNo:"(0452) 666 61 00", adress: "Bucak, Dr. Sadık Ahmet Cd., Altınordu/Ordu"),
        TaksiDurak(name: "Sağlam Taksi"     , lattitude: 40.980377 , longtitude:  37.884925, telNo:"0543 441 52 00"  , adress: "Bucak, 344. Sk., Altınordu/Ordu"),
        TaksiDurak(name: "Bucak Taksi"      , lattitude: 40.977695 , longtitude:  37.876756, telNo:"0536 243 77 98"  , adress: "Bucak, Nefsi Bucak Cd., Altınordu/Ordu"),
        TaksiDurak(name: "Sağlık Taksi"     , lattitude: 40.976927 , longtitude:  37.884538, telNo:"(0452) 214 31 02", adress: "Bucak, İbn-i Sina Cd., Altınordu/Ordu"),
        TaksiDurak(name: "Yonca Taksi"      , lattitude: 40.974850 , longtitude:  37.891216, telNo:"Nil"             , adress: "Yeni, Mevlana Cd. No:14, Altınordu/Ordu"),
        TaksiDurak(name: "Başak Taksi"      , lattitude: 40.973478 , longtitude:  37.892864, telNo:"Nil"             , adress: "Yeni, 337. Sk. No:8, Altınordu/Ordu"),
        TaksiDurak(name: "Otogar Taksi"     , lattitude: 40.979743 , longtitude:  37.934225, telNo:"(0452) 233 74 77", adress: "Yeni, 331. Sk. No:3, Altınordu/Ordu"),
        TaksiDurak(name: "Akyazı Taksi"     , lattitude: 40.977121 , longtitude:  37.912932, telNo:"(0452) 233 47 99", adress: "Akyazı, Ali Rıza Gürsoy Cd., Altınordu/Ordu")
    ]
}

