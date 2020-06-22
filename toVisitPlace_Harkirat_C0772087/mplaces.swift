//
//  Places.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-16.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import Foundation

class mplaces{
     var placeLat: Double
    var placeLong: Double
    var placeName :String
    var city :String
    var postalCode : String
    var country : String
    init(placeLat:Double , placeLong: Double, placeName:String, city:String, postalCode: String, country:String) {
        self.placeLat = placeLat
        self.placeLong = placeLong
        self.placeName = placeName
        self.city = city
        self.postalCode = postalCode
        self.country = country
    }
}
