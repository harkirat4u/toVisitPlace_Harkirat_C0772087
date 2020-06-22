//
//  TableView1.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-16.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import Foundation
import UIKit

class FirstTableView: UITableViewController {
    var places : [mplaces]?
        
        var deleteArray : [mplaces]?
        
        let defaults = UserDefaults.standard
        
        override func viewDidLoad() {
            super.viewDidLoad()
              
        }
        
        override func viewWillAppear(_ animated: Bool) {
            loadData()
            self.tableView.reloadData()
            
        }
        
        func getDataFilePath() -> String {
               let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
               let filePath = documentPath.appending("/places.txt")
               return filePath
           }
        
        func loadData() {
            places = [mplaces]()
            
            let filePath = getDataFilePath()
            
            if FileManager.default.fileExists(atPath: filePath){
                do{
                 let fileContent = try String(contentsOfFile: filePath)
                    
                    let contentArray = fileContent.components(separatedBy: "\n")
                    for content in contentArray{
                       
                        let placeContent = content.components(separatedBy: ",")
                        if placeContent.count == 6 {
                            let place = mplaces(placeLat: Double(placeContent[0]) ?? 0.0, placeLong: Double(placeContent[1]) ?? 0.0, placeName: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5])
                            places?.append(place)
                        }
                }
                }
                catch{
                    print(error)
                }
            }
        }
        
        func deleteRow() {
            let filePath = getDataFilePath()

            var saveString = ""
            for place in self.deleteArray!{
               saveString = "\(saveString)\(place.placeLat),\(place.placeLong),\(place.placeName),\(place.city),\(place.country),\(place.postalCode)\n"
                do{
               try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                }
                catch{
                    print(error)
                }
            }
        }
 override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                    section: Int) -> String? {
           return "Your Favourite Places are:"
        }

        override func numberOfSections(in tableView: UITableView) -> Int {
             return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return places?.count ?? 0
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let place = self.places![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstcell")
            cell?.textLabel?.text = place.placeName + " , " + place.city
            cell?.detailTextLabel?.text = place.country + " , " + place.postalCode
            

            return cell!
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let editedPlace =  self.places![indexPath.row]
            
            defaults.set(editedPlace.placeLat, forKey: "latitude")
            defaults.set(editedPlace.placeLong, forKey: "longitude")
            defaults.set(true, forKey: "bool")
            defaults.set(indexPath.row, forKey: "edit")
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "location") as! TableMapView

            self.navigationController?.pushViewController(controller, animated: true)
            
        }

        override func tableView(_ tableView: UITableView, commit Style: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if Style == .delete {
                
                self.places?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.deleteArray = self.places
                deleteRow()
       } else if Style == .insert {
            }
        }
    }

