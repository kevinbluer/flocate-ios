//
//  SecondViewController.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/16/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit
import CoreData

class FlocateSettings: UIViewController {
    @IBOutlet weak var settingsFirstname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataDictionary: AnyObject? = nil;
        var documentList = NSBundle.mainBundle().pathForResource("data", ofType:"plist")
        dataDictionary = NSDictionary(contentsOfFile: documentList!)
        println(" \(__FUNCTION__)Fetching 'data.plist 'file \n \(documentList) \n")
        
        println(dataDictionary!["firstname"])
        println(dataDictionary!["lastname"])
        println(dataDictionary!["age"])
        
        settingsFirstname.text = dataDictionary!["firstname"] as String
        
        // var locations = Locations()
        
    }
    @IBAction func logoutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Username")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

