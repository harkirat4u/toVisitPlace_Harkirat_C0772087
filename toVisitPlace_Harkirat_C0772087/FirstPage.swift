//
//  FirstPage.swift
//  toVisitPlace_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-15.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import Foundation
import UIKit
class FirstPage: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func btn(_ sender: UIButton) {
        performSegue(withIdentifier: "first", sender: nil);
    }
    
}
