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
    @IBOutlet weak var settingsLastname: UILabel!
    @IBOutlet weak var settingsEmail: UILabel!
    @IBOutlet weak var settingsPlacesCount: UILabel!
    @IBOutlet weak var settlingsCountriesCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)

        var currentUser = PFUser.currentUser()
        currentUser.refresh()
        
        settingsFirstname.text = currentUser.username
        settingsLastname.text = currentUser.email
        
        var query = PFQuery(className:"Checkin")
        query.whereKey("User", equalTo:PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.settingsPlacesCount.text = "You've recorded \(objects.count) places!"
            }
        }
        
        if currentUser != nil {
            
            var countryList = currentUser["CountryList"] as NSArray
            settlingsCountriesCount.text = "You've been to \(countryList.count) countries"
            
            if countryList.count > 0 {
                settlingsCountriesCount.text = settlingsCountriesCount.text + " " + countryList[0] + "!"
            } else {
                settlingsCountriesCount.text += settlingsCountriesCount.text + "!"
            }
            
        }
        
        // TODO save the above to local storage (and pull from this first)...before updating from parse
        
//      
        
        
        
//        var dataDictionary: AnyObject? = nil;
//        var documentList = NSBundle.mainBundle().pathForResource("data", ofType:"plist")
//        dataDictionary = NSDictionary(contentsOfFile: documentList!)
//        println(" \(__FUNCTION__)Fetching 'data.plist 'file \n \(documentList) \n")
        
//        println(dataDictionary!["firstname"])
//        println(dataDictionary!["lastname"])
//        println(dataDictionary!["age"])
        
        // settingsFirstname.text = dataDictionary!["firstname"] as String
        
        // var locations = Locations()
        
    }
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOut()
        
        // TODO - Also logout reset all of the other views
        // TODO - Clear down all the NSUserDefaults too
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

