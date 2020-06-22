//
//  TableView.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-16.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TableMapView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var editMap: MKMapView!
   
  let defaults = UserDefaults.standard
    var lat : Double = 0.0
    var long : Double = 0.0
    var drag : Bool? = false
    var editedPlace : Int = 0
    var editPlaces : [mplaces]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editMap.delegate = self

        self.navigationItem.title = "your location"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
               
        
       
                
        self.editMap.addAnnotation(dragablePin())
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
         
         
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let customLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: customLocation, span: span)
               
         
        editMap.setRegion(region, animated: true)
        
        loadData()
    
    }
   func dragablePin() -> MKPointAnnotation{
    self.lat = defaults.double(forKey: "latitude")
    self.long = defaults.double(forKey: "longitude")
    
    self.drag = defaults.bool(forKey: "bool")
    
    print("Lat: \(lat): Long: \(long)")
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)

    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { (placemarks, error) in
        if let places = placemarks {
            for place in places {
                annotation.title = place.name
                annotation.subtitle = "\(place.locality!) ,  \(place.postalCode!)"
            }
        }
    }
    //        self.mapView.addAnnotation(annotation)
    return annotation
    
    
    }
     
        func getDataFilePath() -> String {
               let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
               let filePath = documentPath.appending("/pinplaces.txt")
               return filePath
           }
        
        func loadData() {
            self.editPlaces = [mplaces]()
            
            let filePath = getDataFilePath()
            
            if FileManager.default.fileExists(atPath: filePath){
                do{
                 let fileContent = try String(contentsOfFile: filePath)
                    
                    let contentArray = fileContent.components(separatedBy: "\n")
                    for content in contentArray{
                       
                        let placeContent = content.components(separatedBy: ",")
                        if placeContent.count == 6 {
                            let place = mplaces(placeLat: Double(placeContent[0]) ?? 0.0, placeLong: Double(placeContent[1]) ?? 0.0, placeName: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5])
                            self.editPlaces?.append(place)
                        }}
                }
                catch{
                    print(error)
                }
            }
        }
        
    
   }

extension TableMapView{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
  
        let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                pinAnnotation.glyphTintColor = .white
                pinAnnotation.isDraggable = true
                pinAnnotation.canShowCallout = true
                pinAnnotation.rightCalloutAccessoryView = UIButton(type: .contactAdd)
                return pinAnnotation
    
    }
    

}
