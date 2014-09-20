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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)

        var currentUser = PFUser.currentUser()
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

