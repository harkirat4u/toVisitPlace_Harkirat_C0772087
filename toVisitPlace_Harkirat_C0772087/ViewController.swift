//
//  ViewController.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-14.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet var PinDrop: UITapGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager  = CLLocationManager()
     let annotation = MKPointAnnotation()
     let destinationRequest = MKDirections.Request()
     let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

     func setupLocationManager(){
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest}
     
     func checklocationServices(){
         if CLLocationManager.locationServicesEnabled(){
             setupLocationManager()
             checkAuthorization()}
     }

     func checkAuthorization(){
         switch CLLocationManager.authorizationStatus(){
     case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
             mapView.showsUserLocation = true
             //locationManager.startUpdatingLocation()
     case .denied:
             break
     case .authorizedAlways:
             mapView.showsUserLocation = true
             centerViewOnUserLocation()
            // locationManager.startUpdatingLocation()
             break
     case .authorizedWhenInUse:
           mapView.showsUserLocation = true
           centerViewOnUserLocation()
           //locationManager.startUpdatingLocation()
             break
     case .restricted:
             break
     @unknown default:
             break
         }
     }
    
    @IBAction func PinDrop(_ sender: UITapGestureRecognizer) {
        let newCoordinates = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
         annotation.coordinate = newCoordinates
         annotation.title = "Pin Droped here"
         mapView.addAnnotation(annotation)
         self.mapView.addAnnotation(annotation)
        print(newCoordinates) //latitude value or longitude value
        
        
        
        let locationData = ["lat": annotation.coordinate.latitude, "long": annotation.coordinate.longitude,"name":"locationName"] as [String : Any]
        UserDefaults.standard.set(locationData, forKey: "pinned_annotation")
        UserDefaults.standard.synchronize()
        
        
 
        
        
    }
    //MARK: - callout accessory control tapped
       func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           let detailVc = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
                    detailVc.lat=self.annotation.coordinate.latitude
                    detailVc.long=self.annotation.coordinate.longitude
//                    detailVc.name = pm.country
                           self.navigationController?.pushViewController(detailVc, animated: true)

               }
        
        
        
       
        
       
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                return nil
            }
    
            // add custom annotation with image
            let pinAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
            pinAnnotation.image = UIImage(named: "ic_place_2x")
            pinAnnotation.canShowCallout = true
            pinAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinAnnotation
        }
}

extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
    func centerViewOnUserLocation() {
    if let location = locationManager.location?.coordinate {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters:10000)
        mapView.setRegion(region, animated: true)
    }

}
}


