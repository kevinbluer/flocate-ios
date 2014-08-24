//
//  LocationMap.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/17/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationMapController: UIViewController {
    @IBOutlet weak var mapLocationsAll: MKMapView!
 
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://api.bluer.com/checkin/get"))
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        request.HTTPMethod = "POST"
        
        var params = ["message":""] as Dictionary
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            let json = JSONValue(data)
            
            if let locationArray = json.array {
                for location in locationArray {
                    
                    println(location["location"][0].double)
                    
                    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location["location"][0].double!, location["location"][1].double!)
                    
                    // add new annotation
                    var pinLocation = MKPointAnnotation()
                    pinLocation.coordinate = currentLocation
                    pinLocation.title = location["message"].string
                    pinLocation.subtitle = location["doing"].string
                    self.mapLocationsAll.addAnnotation(pinLocation)
                    
                }
            }
        })
        
        task.resume()
        
        // TODO - set the map to the last selected location
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}