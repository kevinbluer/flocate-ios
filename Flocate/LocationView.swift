//
//  SecondViewController.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/16/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate  {
    @IBOutlet weak var loadLatest: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var firstLoad:Bool = true
    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var addressBar: UISearchBar!
    @IBOutlet weak var imageCategory: UIButton!
    
    var items: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if firstLoad {
            populateTable("")
            firstLoad = false
        }
        
        addressBar.delegate = self
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func newViewForHeaderOrFooterWithText(text: String) -> UIView{
        let headerLabel = newLabelWithTitle(text)
        
        /* Move the label 10 points to the right */
        headerLabel.frame.origin.x += 10
        /* Go 5 points down in y axis */
        headerLabel.frame.origin.y = 5
        
        /* Give the container view 10 points more in width than our label
        because the label needs a 10 extra points left-margin */
        let resultFrame = CGRect(x: 0,
            y: 0,
            width: headerLabel.frame.size.width + 10,
            height: headerLabel.frame.size.height)
        
        let headerView = UIView(frame: resultFrame)
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func newLabelWithTitle(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        return label
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        if (addressBar.text == "") {
            populateTable("")
        } else {
            populateTable(addressBar.text)
        }
    }
    
    func searchBarTextDidBeginEditing( searchBar: UISearchBar!) {
        if (addressBar.text == "") {
            populateTable("")
        } else {
            populateTable(addressBar.text)
        }
    }
    
    func tableView(tableView: UITableView!,
        titleForHeaderInSection section: Int) -> String!{
            var returnHeader = "Grouping"
            
            // TODO - Figure out why 'section' is always 0
            
            if self.items.count > 0 {
                var note = self.items[section]["Note"] as String
                println(section)
                if note == "Central, Hong Kong" {
                    // println("there")
                    // returnHeader = self.items[section]["Note"] as String
                    newViewForHeaderOrFooterWithText(note)
                } else {
                    // println("here")
                    newViewForHeaderOrFooterWithText(note)
                    returnHeader = note
                }
                
            }
            
            return returnHeader
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("tvcItems") as UITableViewCell
        
        var notes:UILabel = cell.viewWithTag(100) as UILabel
        notes.text = self.items[indexPath.row]["Doing"] as String?
        
        var doing:UILabel = cell.viewWithTag(99) as UILabel
        
        var category:UIButton = cell.viewWithTag(98) as UIButton
        var img:UIImage = UIImage(named: "953-paw-print")!
        
        var cat = self.items[indexPath.row]["Category"] as String?
        
        if cat == nil {
            cat = ""
        }
        
        switch (cat!) {
            case "car":
                img = UIImage(named: "815-car")!
                break;
            case "walk":
                img = UIImage(named: "944-walking-man")!
                break;
            case "study":
                img = UIImage(named: "897-graduation-cap")!
                break;
            case "work":
                img = UIImage(named: "1008-desktop")!
                break;
            case "food":
                img = UIImage(named: "932-utensils")!
                break;
            case "drink":
                img = UIImage(named: "957-beer-mug")!
                break;
            case "paw":
                img = UIImage(named: "953-paw-print")!
                break;
            case "study":
                img = UIImage(named: "897-graduation-cap")!
                break;

            
          default:
            break;
        }
        
        category.setImage(img, forState: UIControlState.Normal)
        
//        var date:NSDate = self.items[indexPath.row].createdAt as NSDate
//        
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        // doing.text = dateFormatter.stringFromDate(date)
        
        doing.text = self.items[indexPath.row]["Note"] as String?
        
        // object["Note"] as String
        
        // cell.textLabel?.text = self.items[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("MapDetail") as LocationDetailViewController;
        vc.entry = self.items[indexPath.row]
        
        self.presentViewController(vc, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!,
        heightForHeaderInSection section: Int) -> CGFloat{
            return 30
    }
    

    @IBAction func clickLoadLatest(sender: AnyObject) {
        
        populateTable("")
    }
    
    func populateTable(filter: String) {
        self.items = []
        self.tableView.reloadData()
        
        var query = PFQuery(className:"Checkin")
        
        query.whereKey("User", equalTo:PFUser.currentUser())
        query.orderByDescending("createdAt")
        
        if filter != "" {
            query.whereKey("Address", containsString: addressBar.text)
        }
        
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
    
    @IBAction func buttonViewLocationDetail(sender: AnyObject) {
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "segueShowLocationDetail"{
//            let vc = segue.destinationViewController as LocationDetailViewController
//            vc.nameString = "hello"
//        }
//    }

    @IBAction func unwindFromView(segue: UIStoryboardSegue) {
        // note that data can be passed with an unwind action
    }
    
}

