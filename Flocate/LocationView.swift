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
    var firstLoad:Bool = true
    
    var items: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if firstLoad {
            populateTable()
            firstLoad = false
        }
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("tvcItems") as UITableViewCell
        
        var notes:UILabel = cell.viewWithTag(100) as UILabel
        notes.text = self.items[indexPath.row]["Note"] as String?
        
        var doing:UILabel = cell.viewWithTag(99) as UILabel
        
        var date:NSDate = self.items[indexPath.row].createdAt as NSDate
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        doing.text = dateFormatter.stringFromDate(date)
        
        // object["Note"] as String
        
        // cell.textLabel?.text = self.items[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil);
//        let vc = storyboard.instantiateViewControllerWithIdentifier("xyz") as UIViewController;
//        self.presentViewController(vc, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickLoadLatest(sender: AnyObject) {
        
        populateTable()
    }
    
    func populateTable() {
        self.items = []
        self.tableView.reloadData()
        
        var query = PFQuery(className:"Checkin")
        query.whereKey("User", equalTo:PFUser.currentUser())
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                
                var counter:Int = 0
                
                for object in objects {
                    
                    self.items += [object]
                    
                    self.tableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
        
        self.tableView.reloadData()

    }

}

