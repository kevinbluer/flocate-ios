//
//  SecondViewController.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/16/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit
import CoreData

class FlocateSettings: UIViewController {
    @IBOutlet weak var settingsFirstname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect : CGRect = CGRectMake(0,0,320,100)
        var vista : UIView = UIView(frame: CGRectMake(0, 0, 320, 600))
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = vista.bounds
        
        let cor1 = UIColor(hex:0xABCA8E).CGColor
        let cor2 = UIColor(hex:0x7DA93D).CGColor
        
        let arrayColors: Array <AnyObject> = [cor1, cor2]
        
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        var dataDictionary: AnyObject? = nil;
        var documentList = NSBundle.mainBundle().pathForResource("data", ofType:"plist")
        dataDictionary = NSDictionary(contentsOfFile: documentList!)
        println(" \(__FUNCTION__)Fetching 'data.plist 'file \n \(documentList) \n")
        
        println(dataDictionary!["firstname"])
        println(dataDictionary!["lastname"])
        println(dataDictionary!["age"])
        
        settingsFirstname.text = dataDictionary!["firstname"] as String
        
        // var locations = Locations()
        
    }
    @IBAction func logoutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Username")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

