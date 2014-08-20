//
//  SecondViewController.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/16/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var loadLatest: UIBarButtonItem!
    @IBOutlet weak var placesList: UILabel!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickLoadLatest(sender: AnyObject) {
        
        // display the loading message
        placesList.hidden = false
        placesList.text = "Loading..."
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://api.bluer.com/checkin/get"))
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["message":""] as Dictionary
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in

            println("Response: \(error)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            self.placesList.text = "Loaded :)"
            
            let json = JSONValue(data)
            
            var locationList = ""
            
            if let locationArray = json.array {
                for location in locationArray {
                    locationList += location["message"].string! + " "
                }
            }
            
            self.placesList.text = locationList;
            
            // TODO - Create entries in the table :)
            
        })
        
        task.resume()

    }

}

