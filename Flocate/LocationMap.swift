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
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonRefresh: UIButton!
    @IBOutlet weak var buttonZoomOut: UIButton!
    @IBOutlet weak var buttonZoomIn: UIButton!
    var locationArray:[AnyObject] = []
    var locationCounter:Int = 0
    var locationTotal:Int = 0
    var currentHeight:CLLocationDegrees = 0.01
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonRefresh.layer.borderColor = UIColor(hex:0xFFFFFF).CGColor
        buttonRefresh.layer.cornerRadius = 5
        buttonRefresh.layer.borderWidth = 1
        buttonRefresh.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        buttonRefresh.layer.backgroundColor = UIColor(hex:0x7DA93D).CGColor
        
        buttonZoomOut.layer.borderColor = UIColor(hex:0xFFFFFF).CGColor
        buttonZoomOut.layer.cornerRadius = 5
        buttonZoomOut.layer.borderWidth = 1
        buttonZoomOut.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        buttonZoomOut.layer.backgroundColor = UIColor(hex:0x7DA93D).CGColor
        
        buttonZoomIn.layer.borderColor = UIColor(hex:0xFFFFFF).CGColor
        buttonZoomIn.layer.cornerRadius = 5
        buttonZoomIn.layer.borderWidth = 1
        buttonZoomIn.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        buttonZoomIn.layer.backgroundColor = UIColor(hex:0x7DA93D).CGColor
        
        refreshMap()
    }
    
    func refreshMap() {
    
        var query = PFQuery(className:"Checkin")
        query.whereKey("User", equalTo:PFUser.currentUser())
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
        (objects: [AnyObject]!, error: NSError!) -> Void in
        if error == nil {
        // The find succeeded.
        
        self.locationTotal = objects.count as Int
        
        var counter:Int = 0
        
        for object in objects {
        
            // append to the array
            self.locationArray.append(object)
            
            var geopoint:PFGeoPoint = object["Location"] as PFGeoPoint
            
            var location = CLLocationCoordinate2D(
            latitude: geopoint.latitude,
            longitude: geopoint.longitude
            )
            
            // add new annotation
            var pinLocation = MKPointAnnotation()
            pinLocation.coordinate = location
            pinLocation.title = (object["Doing"] as String)
            self.mapLocationsAll.addAnnotation(pinLocation)
            
            // if it's the latest pin, zoom in and show the info
            if counter == 0 {
                var span = MKCoordinateSpanMake(self.currentHeight, self.currentHeight)
                var region = MKCoordinateRegion(center: location, span: span)
                self.mapLocationsAll.setRegion(region, animated: true)
                self.mapLocationsAll.selectAnnotation(pinLocation, animated: true)
                self.labelLocation.text = object["Note"] as String
            }
            
            counter++
            }
        } else {
        // Log details of the failure
        NSLog("Error: %@ %@", error, error.userInfo!)
        }
        }
    }
    
    @IBAction func buttonTouchUpPrevious(sender: AnyObject) {
        
        if locationCounter != locationTotal-1 {
        
            locationCounter++
            
            var object:AnyObject = locationArray[locationCounter] as AnyObject
            
            var geopoint:PFGeoPoint = object["Location"] as PFGeoPoint
            
            var location = CLLocationCoordinate2D(
                latitude: geopoint.latitude,
                longitude: geopoint.longitude
            )
            
            var span = MKCoordinateSpanMake(0.01, 0.01)
            var region = MKCoordinateRegion(center: location, span: span)
            self.mapLocationsAll.setRegion(region, animated: true)
            
            // add new annotation
            var pinLocation = MKPointAnnotation()
            pinLocation.coordinate = location
            self.labelLocation.text = object["Note"] as String
            pinLocation.title = (object["Doing"] as String)
            self.mapLocationsAll.addAnnotation(pinLocation)
            self.mapLocationsAll.selectAnnotation(pinLocation, animated: true)
        
        } else {
            
            // disable the button
        }
        
    }
    
    @IBAction func buttonTouchUpNext(sender: AnyObject) {
        
        if locationCounter != 0 {
            
            locationCounter--
            
            var object:AnyObject = locationArray[locationCounter] as AnyObject
            
            var geopoint:PFGeoPoint = object["Location"] as PFGeoPoint
            
            var location = CLLocationCoordinate2D(
                latitude: geopoint.latitude,
                longitude: geopoint.longitude
            )
            
            var span = MKCoordinateSpanMake(0.01, 0.01)
            var region = MKCoordinateRegion(center: location, span: span)
            self.mapLocationsAll.setRegion(region, animated: true)
            
            // add new annotation
            var pinLocation = MKPointAnnotation()
            pinLocation.coordinate = location
            self.labelLocation.text = object["Note"] as String
            pinLocation.title = (object["Doing"] as String)
            self.mapLocationsAll.addAnnotation(pinLocation)
            self.mapLocationsAll.selectAnnotation(pinLocation, animated: true)
            
        } else {
            
            // disable the button
        }
        
    }
    
    @IBAction func buttonTouchUpZoomIn(sender: AnyObject) {
        
        if (currentHeight > 0.01) {
        
            currentHeight -= 1
            
            var currentRegion = mapLocationsAll.region
            currentRegion.span.latitudeDelta = currentHeight
            currentRegion.span.longitudeDelta = currentHeight
            self.mapLocationsAll.setRegion(currentRegion, animated: true)
        }
    }
    
    @IBAction func buttonTouchUpZoomOut(sender: AnyObject) {
        
        if currentHeight < 100.01 {
            
            currentHeight += 1
        
            var currentRegion = mapLocationsAll.region
            currentRegion.span.latitudeDelta = currentHeight
            currentRegion.span.longitudeDelta = currentHeight
            self.mapLocationsAll.setRegion(currentRegion, animated: true)
        }
    }
    
    @IBAction func buttonTouchUpRefresh(sender: AnyObject) {
        locationCounter = 0
        currentHeight = 0.01
        refreshMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
}