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
    var entry:AnyObject = "x"
    @IBOutlet weak var labelLocationWhat: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    
    override func viewDidLoad() {
        labelLocationName.text = entry["Note"] as String!
        labelLocationWhat.text = entry["Doing"] as String!
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
        
        buttonDone.layer.cornerRadius = 5
        buttonDone.layer.borderWidth = 1
        buttonDone.layer.borderColor = UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ).CGColor
    }
    
}