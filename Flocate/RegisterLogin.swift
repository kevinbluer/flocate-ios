//
//  RegisterLogin.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/24/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit
import Foundation

class RegisterLoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        
        // TODO - Get this value from the user
        // TODO - Provide both registration and simple login
        // TODO - Investigate OAuth strategy
        
        var myValue:NSString = "kevin"
        
        NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"Username")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
}