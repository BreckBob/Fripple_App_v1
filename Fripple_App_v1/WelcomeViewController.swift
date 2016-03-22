//
//  WelcomeViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/21/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class WelcomeViewController: UIViewController {
    
    let permissions = ["public_profile"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getStarted(sender: AnyObject) {
        
        self.goToCommandCentral()
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        let login = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(login, animated: false, completion: nil)
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        let signup = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.presentViewController(signup, animated: false, completion: nil)
        
    }
    
    
    @IBAction func whySignUp(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Why sign up?", message: "Signing up gives you the ability to send and recieve Fripples from friends as well as track results of Fripples sent or taken. Doesn't that sound great?!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "View Privacy Policy", style: .Default, handler: { (action) -> Void in
            let privacy = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyViewController") as! PrivacyViewController
            self.presentViewController(privacy, animated: false, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
//    @IBAction func fbLoginClick(sender: AnyObject) {
//        
//        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
//            (user: PFUser?, error: NSError?) -> Void in
//            if let user = user {
//                if user.isNew {
//                    print("User signed up and logged in through Facebook!")
//                    user.saveInBackground()
//                    self.goToCommandCentral()
//                } else {
//                    print("User logged in through Facebook!")
//                    self.goToCommandCentral()
//                }
//            } else {
//                print("Uh oh. The user cancelled the Facebook login.")
//            }
//        }
//    }
    
    func goToCommandCentral() {
        
        let container = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        self.presentViewController(container, animated: false, completion: nil)
        
    }
    
    
}
