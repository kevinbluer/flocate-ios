//
//  LocationDetailView.swift
//  Flocate
//
//  Created by Kevin Bluer on 9/23/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController  {
    @IBOutlet weak var labelLocationName: UILabel!
    var nameString:String = "yo"
    
    override func viewDidLoad() {
        labelLocationName.text = nameString
    }
    
}