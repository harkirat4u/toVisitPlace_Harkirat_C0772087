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
     var locationManager:CLLocationManager!
    let annotation = MKPointAnnotation()
    let destinationRequest = MKDirections.Request()
    var vcplace:[mplaces] = [mplaces]()
     let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        loadData()
        // Do any additional setup after loading the view.
    }

     func setupLocationManager(){
        locationManager = CLLocationManager()
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.delegate = self}
  
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
        print(newCoordinates)}
    
    func getDataFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/places.txt")
        return filePath
    }
        func loadData() {
             vcplace = [mplaces]()
           let filePath = getDataFilePath()
           if FileManager.default.fileExists(atPath: filePath){
                do{
                 let fileContent = try String(contentsOfFile: filePath)
                 let contentArray = fileContent.components(separatedBy: "\n")
                    for content in contentArray{
                     let placeContent = content.components(separatedBy: ",")
                        if placeContent.count == 6 {
                            let place = mplaces(placeLat: Double(placeContent[0]) ?? 0.0, placeLong: Double(placeContent[1]) ?? 0.0, placeName: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5])
                            vcplace.append(place)
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
        }

        
         
    
    func saveData() {
        let filePath = getDataFilePath()

        var saveString = ""
        for place in vcplace{
           saveString = "\(saveString)\(place.placeLat),\(place.placeLong),\(place.placeName),\(place.city),\(place.country),\(place.postalCode)\n"
            do{
           try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
            }
            catch{
                print(error)
            }
        }
    }
      func mapcode()  {

        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)) {  placemark, error in
               if let error = error as? CLError {
                   print("CLError:", error)
                   return
                }
               else if let placemark = placemark?[0] {
                
                var placeName = ""
                var neighbourhood = ""
                var city = ""
                var state = ""
                var postalCode = ""
                var country = ""
                if let name = placemark.name {
                    placeName = placeName+name
                            }
                if let sublocality = placemark.subLocality {
                    neighbourhood = neighbourhood+sublocality
                            }
                if let locality = placemark.subLocality {
                     city += locality
                            }
                if let area = placemark.administrativeArea {
                              state += area
                          }
                if let code = placemark.postalCode {
                              postalCode += code
                          }
                if let cntry = placemark.country {
                                        country += cntry
                                    }
                let place = mplaces(placeLat: self.annotation.coordinate.latitude, placeLong:self.annotation.coordinate.longitude, placeName: placeName, city: city, postalCode: postalCode, country: country)
                self.vcplace.append(place)
                self.saveData()
               
 
                }
            
            }
        }
 
    //MARK: - callout accessory control tapped
       func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
   
    let alertController = UIAlertController(title: "Favourites", message:
            "add marked Location to favourites?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (UIAlertAction) in
            self.mapcode()
            
        }))
    
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
    }

     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                return nil
        }
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


