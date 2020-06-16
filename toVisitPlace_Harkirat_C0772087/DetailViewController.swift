//
//  DetailViewController.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-15.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var latitude: UILabel!
    
   
    var long = 0.0
    var lat = 0.0
    var Countryname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text=Countryname
        latitude.text = String(format: "Lat:%6.f //lon:%6.f", lat,long)
        
        
        // Do any additional setup after loading the view.
    }
    


}
