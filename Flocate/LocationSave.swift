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

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var saveLocationButton: UIButton!
    @IBOutlet weak var locationNote: UITextField!
    @IBOutlet weak var locationDoing: UITextField!
    @IBOutlet weak var mapCurrentLocation: MKMapView!
    @IBOutlet weak var buttonCategoryWorld: UIButton!
    @IBOutlet weak var scrollViewCategory: UIScrollView!
    @IBOutlet weak var buttonCategoryCar: UIButton!
    
    var manager:CLLocationManager!
    var lat:Double?
    var lng:Double?
    
    var category:String = ""
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        locationNote.delegate = self
        locationDoing.delegate = self
        
        buttonCategoryCar.imageView?.image?.imageWithColor(UIColor.whiteColor())
        
        scrollViewCategory.contentSize = CGSizeMake(400, 42);
        
        super.viewDidLoad()
        
        saveLocationButton.layer.cornerRadius = 5
        saveLocationButton.layer.borderWidth = 1
        saveLocationButton.layer.borderColor = UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ).CGColor
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
        
        // style the map
        mapCurrentLocation.layer.borderColor = UIColor(hex:0xFFFFFF).CGColor
        mapCurrentLocation.layer.cornerRadius = 5
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
//    
//    override func viewDidLayoutSubviews() {
//        //self.scrollViewCategory.delegate = self
//        scrollViewCategory.setContentOffset(CGPointMake(0,-50), animated: true)
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // attempt to get the username from NSUserDefaults
        var username: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Username")
        
        // see if the user exists, otherwish present the RegisterLogin ViewController
        if (username == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewControllerWithIdentifier("signup") as UIViewController;
            self.presentViewController(vc, animated: true, completion: nil);
        }
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            println(currentUser.objectId)
        } else {
            // Show the signup or login screen
            
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
        self.mapCurrentLocation.addAnnotation(pinLocation)
        
        // get location name
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                    self.locationNote.text = pm.subLocality + ", " + pm.locality
                    println(pm.areasOfInterest)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
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
            
            var checkin = PFObject(className: "Checkin")
            checkin.setObject(locationNote.text, forKey: "Note")
            checkin.setObject(locationDoing.text, forKey: "Doing")
            checkin.setObject(location, forKey: "Location")
            
            var relation = checkin.relationForKey("User")
            relation.addObject(PFUser.currentUser())
            
            checkin.saveInBackground()
            
            // update the textbox
            saveLocationButton.titleLabel?.text = "Add Your Footprint"
            saveLocationButton.enabled = true
        }
    }
    
    @IBAction func buttonTouchUpCategoryWorld(sender: AnyObject) {
        
        // TODO it appears multiple buttons can be wired up to the same IBAction
        // TODO check that "self" allows us to get at the actual element
        
        if true {
            println(sender)
        }
    }
    
    // hide the keyboard when the user presses return
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        locationNote.resignFirstResponder()
        locationDoing.resignFirstResponder()
        return true;
    }
}

