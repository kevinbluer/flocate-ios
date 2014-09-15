//
//  FirstViewController.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/16/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var saveLocationButton: UIButton!
    @IBOutlet weak var locationNote: UITextField!
    @IBOutlet weak var locationDoing: UITextField!
    @IBOutlet weak var mapCurrentLocation: MKMapView!
    
    var manager:CLLocationManager!
    var lat:Double?
    var lng:Double?
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO - determine the orientation (may need to handle orientation changes too)
        // Consider programmatically adding a constraint to the sublayer
        
        let rect : CGRect = CGRectMake(0,0,320,100)
        var vista : UIView = UIView(frame: CGRectMake(0, 0, 320, 600))
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = vista.bounds
        
        let cor1 = UIColor(hex:0xABCA8E).CGColor
        let cor2 = UIColor(hex:0x7DA93D).CGColor
        
        let arrayColors: Array <AnyObject> = [cor1, cor2]
        
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        // style the map
        mapCurrentLocation.layer.borderColor = UIColor(hex:0xFFFFFF).CGColor
        mapCurrentLocation.layer.borderWidth = 2
        
        
        // set the title bars text to white
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        
        // establish location and start the location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // check if the OS is iOS 8
        var version:NSString = UIDevice.currentDevice().systemVersion as NSString;
        if  version.doubleValue >= 8 {
            manager.requestAlwaysAuthorization()
        }
        
        manager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO - determine if use is loggedin (NSUserDefaults)
        // TODO - turn this into the dashboard screen
        
        // attempt to get the username from NSUserDefaults
        var username: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Username")
        
        // see if the user exists, otherwish present the RegisterLogin ViewController
        if (username == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewControllerWithIdentifier("signup") as UIViewController;
            self.presentViewController(vc, animated: true, completion: nil);
        }
        
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        
        // set the lat & lng for future save
        lat = coord.latitude
        lng = coord.longitude
        
        var latDelta:CLLocationDegrees = 0.01
        var lngDelta:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(coord.latitude, coord.longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocation, theSpan)
        
        self.mapCurrentLocation.setRegion(region, animated: true)
        
        // remove all existing annotations
        self.mapCurrentLocation.removeAnnotations(self.mapCurrentLocation.annotations)
    
        // add new annotation
        var pinLocation = MKPointAnnotation()
        pinLocation.coordinate = currentLocation
        pinLocation.title = "You are here"
        self.mapCurrentLocation.addAnnotation(pinLocation)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveLocation(sender: AnyObject) {
        
        println("saving location")
        
        // check that we have the location first
        if (lat == nil && lng == nil) {
            
            if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
                
                println("UIAlertController can be instantiated")
                
                //make and use a UIAlertController
                var alert = UIAlertController(title: "Location Unknown", message: "Flocate was unable to determine your location", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else {
                
                println("UIAlertController can NOT be instantiated")
                
                // make and use a UIAlertView
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Here's a message"
                alert.addButtonWithTitle("Understod")
                alert.show()
            }
            
            
            
            saveLocationButton.titleLabel?.text = "Save Location"
            saveLocationButton.enabled = true
        
        // also theck that the user has
        } else if (locationNote.text == "") {
            
            if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
                
                println("UIAlertController can be instantiated")
                
                //make and use a UIAlertController
                var alert = UIAlertController(title: "Enter Name", message: "Please enter a place name", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else {
                
                println("UIAlertController can NOT be instantiated")
                
                // make and use a UIAlertView
                let alert = UIAlertView()
                alert.title = "Enter Name"
                alert.message = "Please enter a place name"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            
        } else {
            
            // update the textbox
            saveLocationButton.titleLabel?.text = "Saving..."
            saveLocationButton.enabled = false

            var location:PFGeoPoint = PFGeoPoint(latitude:lat!, longitude:lng!)
            
            var object = PFObject(className: "Checkin")
            object.setObject(locationNote.text, forKey: "Note")
            object.setObject(locationDoing.text, forKey: "Doing")
            object.setObject(location, forKey: "Location")
            object.saveInBackground()
            
            // update the textbox
            saveLocationButton.titleLabel?.text = "Add Your Footprint"
            saveLocationButton.enabled = true
        }
    }
    
    // hide the keyboard when the user presses return
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        locationNote.resignFirstResponder()
        return true;
    }
}

