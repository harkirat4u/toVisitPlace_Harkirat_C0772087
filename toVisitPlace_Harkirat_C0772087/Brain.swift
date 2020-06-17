//
//  Brain.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-16.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import Foundation
class Brain{
    
   static func addLocation(place: Places){
       
       var places = getAllPlaces()
       places.append(place)
       setPlaces(places: places)
       
   }
   
   static func setPlaces(places: [Places]){
       let userDefaults = UserDefaults.standard
          let encodedData: Data =  NSKeyedArchiver.archivedData(withRootObject: places)
          userDefaults.set(encodedData, forKey: "places")
          userDefaults.synchronize()
   }
   
   
   static func removePlace(place: Places){
       var places = getAllPlaces()
       places.removeAll { (plc) -> Bool in
           plc.key == place.key
       }
       setPlaces(places: places)
   }
   
   
   static func updatePlace(placeFrom: Places, placeTo: Places){
       removePlace(place: placeFrom)
       addLocation(place: placeTo)
   }
   
   static func getAllPlaces() -> [Places]{
       let userDefaults = UserDefaults.standard
       let decoded  = userDefaults.data(forKey: "places")
       if decoded == nil{
           return [Places]()
       }
       let decodedPlaces = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Places]
       return decodedPlaces
   }
}
