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
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if firstLoad {
            populateTable("")
            firstLoad = false
        }
        
        addressBar.delegate = self
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        // this function determines where each row goes
        // if date falls within a certain range than determine it here
        // note that this is called for each section...as returned in the function below
        
        // aha - section is the index of the section
        
        
        
//        if self.items.count > 0 {
//            
//            // TODO need to determine the current item in context item
//            
//            var days:Int = daysBetweenDate(items[section].createdAt, toDateTime:NSDate())
//            
//            if days == 0 {
//                
//                // actually return the number that match (else return hmmm...the number that??)
//                return 1
//                
//            } else {
//                println("yesterday yo")
//            }
////
//        }
        
        
        
        
        return self.items.count;
    }
    
    func daysBetweenDate(fromDateTime:NSDate, toDateTime:NSDate) -> Int {
        
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .DayCalendarUnit
        
        let components = cal.components(unit, fromDate: fromDateTime, toDate: toDateTime, options: nil)
        
        return components.day
    }
    
    // determines the number of sections
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
        // println("here")
        return 1
    }
    
    // this is the section that determines what header it appears under
    // note that the
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String!{
            
            // println(section);
            
            // NOTE
            // These are rendered upon
            
            var returnHeader = "Last Month"
            
            if section == 1 {
                returnHeader = "Yesterday"
            } else if section == 2 {
                returnHeader = "Prior"
            }
            
            //            if self.items.count > 0 {
            //                var note = self.items[section]["Note"] as String
            //                if note == "Central, Hong Kong" {
            //                    println("there")
            //                    // returnHeader = self.items[section]["Note"] as String
            //                    newViewForHeaderOrFooterWithText(note)
            //                    returnHeader = "Yo"
            //                } else {
            //                    //println("here")
            //                    // newViewForHeaderOrFooterWithText(note)
            //                    returnHeader = "Today"
            //                }
            //                
            //            }
            
            return returnHeader
    }
    
//    func sectionIndexTitlesForTableView(tableView: UITableView!) -> NSArray {
//        return sectionTitles
//    }
    
    // facilitates the jumping to the respective section (from the index list on the left hand side of the table)
//    func sectionForSectionIndexTitle(tableView: UITableView!, sectionForSectionIndexTitle title: NSString, atIndex index: NSInteger) -> NSInteger {
//        return 0
//    }
    
//    func newViewForHeaderOrFooterWithText(text: String) -> UIView{
//        let headerLabel = newLabelWithTitle(text)
//        
//        /* Move the label 10 points to the right */
//        headerLabel.frame.origin.x += 10
//        /* Go 5 points down in y axis */
//        headerLabel.frame.origin.y = 5
//        
//        /* Give the container view 10 points more in width than our label
//        because the label needs a 10 extra points left-margin */
//        let resultFrame = CGRect(x: 0,
//            y: 0,
//            width: headerLabel.frame.size.width + 10,
//            height: headerLabel.frame.size.height)
//        
//        let headerView = UIView(frame: resultFrame)
//        headerView.addSubview(headerLabel)
//        
//        return headerView
//    }
//    
//    func newLabelWithTitle(title: String) -> UILabel{
//        let label = UILabel()
//        label.text = title
//        label.backgroundColor = UIColor.clearColor()
//        label.sizeToFit()
//        return label
//    }
    
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
    
//    func tableView(tableView: UITableView!,
//    viewForHeaderInSection section: Int) -> UIView!{
//        println("mornin")
//        return newViewForHeaderOrFooterWithText("Section \(section) Header")
//    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
//        println(indexPath)
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("tvcItems", forIndexPath: indexPath) as UITableViewCell
        
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
        
        vc.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
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
                    
                    // TODO consider putting into a dictionary with categories (today, yesterday, last week, last month, older)
                    
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
    
//    @IBAction func buttonViewLocationDetail(sender: AnyObject) {
//        
//    }
    
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

