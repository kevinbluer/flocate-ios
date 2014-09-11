//
//  SecondViewController.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/16/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate  {
    @IBOutlet weak var loadLatest: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil);
//        let vc = storyboard.instantiateViewControllerWithIdentifier("xyz") as UIViewController;
//        self.presentViewController(vc, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickLoadLatest(sender: AnyObject) {
        
        self.items = []
        self.tableView.reloadData()
        
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
                    
                    self.items += [location["message"].string! + " (" + location["date"].string! + ")"]
                }
            }
            
            self.items = self.items.reverse()
            
            self.tableView.reloadData()
        })
        
        task.resume()

    }

}

