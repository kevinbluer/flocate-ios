//
//  LocationDetailView.swift
//  Flocate
//
//  Created by Kevin Bluer on 9/23/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController  {
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var labelLocationWhat: UILabel!
    @IBOutlet weak var labelLocationWhere: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var mapLocation: MKMapView!
    var entry:AnyObject = ""
    @IBOutlet weak var labelLocationAddress: UILabel!
    @IBOutlet weak var labelLocationDetailedDate: UILabel!
    
    func daysBetweenDate(fromDateTime:NSDate, toDateTime:NSDate) -> Int {
        
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .DayCalendarUnit
        
        let components = cal.components(unit, fromDate: fromDateTime, toDate: toDateTime, options: nil)
        
        return components.day
    }
    
    override func viewDidLoad() {
        
        var days:Int = daysBetweenDate(entry.createdAt, toDateTime:NSDate.date())
        
        var message:String = ""
        
        switch (days) {
            case 0:
                message = "Today"
                break;
            case 1:
                message = "Yesterday"
                break;
            default:
                message = "\(days) days ago"
                break;
        }
        
        labelLocationName.text = message

        labelLocationWhat.text = entry["Note"] as String!
        labelLocationWhere.text = entry["Doing"] as String!
        labelLocationAddress.text = entry["Address"] as String!
        
        if entry["RecordedAt"] != nil {
            println(entry["RecordedAt"])
//            var formatter:NSDateFormatter = NSDateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            var date:NSDate = entry["RecordedAt"] as NSDate
//            labelLocationDetailedDate.text = formatter.stringFromDate(date)
        }
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
        
        buttonDone.layer.cornerRadius = 5
        buttonDone.layer.borderWidth = 1
        buttonDone.layer.borderColor = UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ).CGColor
        
        var geopoint:PFGeoPoint = entry["Location"] as PFGeoPoint!
        
        var location = CLLocationCoordinate2D(
            latitude: geopoint.latitude,
            longitude: geopoint.longitude
        )
        
        mapLocation.layer.borderColor = UIColor(hex:0xFFFFFF).CGColor
        mapLocation.layer.cornerRadius = 5
        mapLocation.layer.borderWidth = 2
        
        // add new annotation
        var pinLocation = MKPointAnnotation()
        pinLocation.coordinate = location
        // pinLocation.title = entry["Doing"] as String
        self.mapLocation.addAnnotation(pinLocation)

        var span = MKCoordinateSpanMake(0.02, 0.02)
        var region = MKCoordinateRegion(center: location, span: span)
        self.mapLocation.setRegion(region, animated: true)
        self.mapLocation.selectAnnotation(pinLocation, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var geopoint:PFGeoPoint = entry["Location"] as PFGeoPoint!
        
        var location = CLLocationCoordinate2D(
            latitude: geopoint.latitude,
            longitude: geopoint.longitude
        )
        
        var cam:MKMapCamera = MKMapCamera()
        cam.centerCoordinate = location
        cam.heading = 0
        cam.pitch = 60
        cam.altitude = 400
        
        self.mapLocation.setCamera(cam, animated: true)
    }
    
}