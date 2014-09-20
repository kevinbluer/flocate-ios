//
//  RegisterLogin.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/24/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class RegisterLoginViewController: UIViewController {

    @IBOutlet weak var registerLoginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textLastName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewRegister: UIView!
    
    override func viewDidLoad() {
        
        var vista: UIView = BackgroundView(frame: CGRectMake(0,0,view.bounds.width,view.bounds.height))
        view.insertSubview(vista, atIndex: 0)
    }
    
    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        
        // TODO - Get this value from the user
        // TODO - Investigate OAuth strategy
        
//        var myValue:NSString = "kevin"
//        
//        NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"Username")
//        // NSUserDefaults.standardUserDefaults().synchronize()
//        
//        self.dismissViewControllerAnimated(true, completion: {})
        
        PFUser.logInWithUsernameInBackground(registerUsername.text, password:registerPassword.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                self.dismissViewControllerAnimated(true, completion: {})
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    
    
    @IBAction func buttonRegisterTouchUp(sender: AnyObject) {
        
        var user:PFUser = PFUser()
        user.email = textEmail.text
        user.password = textPassword.text
        user.username = textUserName.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                
                self.dismissViewControllerAnimated(true, completion: {})
                
            } else {
//                let errorString = error.userInfo["error"]
                // Show the errorString somewhere and let the user try again.
            }
        }
    }
    
    @IBAction func loginRegisterChanged(sender: AnyObject) {
        
        if registerLoginSegmentedControl.titleForSegmentAtIndex(registerLoginSegmentedControl.selectedSegmentIndex) == "Register" {
            
            viewRegister.hidden = false
            viewLogin.hidden = true
            
            
        } else {
            
            viewRegister.hidden = true
            viewLogin.hidden = false
        }
        
        
    }
}