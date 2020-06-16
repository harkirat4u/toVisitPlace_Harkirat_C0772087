//
//  Places.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-16.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import Foundation

class Places:   NSObject, NSCoding   {
    func encode(with coder: NSCoder) {
       coder.encode(key, forKey: "key")
        coder.encode(latitude, forKey: "latitude")
       coder.encode(longitude, forKey: "longitude")
  }
    
    required convenience init?(coder decoder: NSCoder) {
        let key = decoder.decodeObject(forKey: "key") as! String
        let latitude = decoder.decodeObject(forKey: "latitude") as! String
        let longitude = decoder.decodeObject(forKey: "longitude") as! String
   self.init(key:key, latitude:latitude, longitude:longitude)
    }
    
    var key: String
    var latitude: String
    var longitude: String
  init( key: String, latitude: String, longitude: String) {
        self.key = key
        self.latitude = latitude
        self.longitude = longitude
    }
}
