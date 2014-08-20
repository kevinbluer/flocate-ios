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

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var saveLocationButton: UIButton!
    @IBOutlet weak var locationNote: UITextField!
    @IBOutlet weak var gpsLocation: UILabel!
    var manager:CLLocationManager!
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        gpsLocation.text = "..."
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        println("locations = \(locations)")
        gpsLocation.text = "locations = \(locations)"
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        
        println(coord.latitude)
        println(coord.longitude)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveLocation(sender: AnyObject) {
        
        saveLocationButton.titleLabel.text = "Saving..."
        saveLocationButton.enabled = false
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://api.bluer.com/checkin/save"))
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["message":"woah"] as Dictionary
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(locationNote.text, forHTTPHeaderField: "message")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            // var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
//            if(err) {
//                println(err!.localizedDescription)
//            }
//            else {
//                //var success = json["success"] as? Int
//                //println("Succes: \(success)")
//            }
            
            
            // TODO Upon response / show success message
            // TODO Hide keyboard (also consider a cancel button)
            
            self.saveLocationButton.titleLabel.text = "Save Location"
            self.saveLocationButton.enabled = true
            
        })
        
        task.resume()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        locationNote.resignFirstResponder()
        return true;
    }
}

