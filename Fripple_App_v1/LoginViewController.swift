//
//  LoginViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/12/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import MessageUI

class LoginViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    let permissions = ["public_profile"]
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    var mailComposer:MFMailComposeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the formats for the view
        self.username.delegate = self
        self.password.delegate = self
        
        self.username.layer.cornerRadius = 5
        self.username.layer.borderWidth = 2
        
        self.password.layer.cornerRadius = 5
        self.password.layer.borderWidth = 2

        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.username.layer.borderColor = borderColor.CGColor
        self.password.layer.borderColor = borderColor.CGColor
        
        self.activityView.layer.cornerRadius = 10
        self.activityLabel.alpha = 0
        self.activityView.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToWelcome(sender: AnyObject) {
        
        let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
        welcome.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(welcome, animated: false, completion: nil)
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var errorMessage = "There was an error, please try again later"
        //Check if the ext fields have data and if not present an error
        if self.username.text == "" || self.password.text == "" {
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            displayAlert("There was an error", message: "Please make sure all fields are filled out")
        }
        else {
            //If successful, login using parse, else present an error
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user, error) -> Void in
                
                if user != nil {
                    self.activityIndicator.stopAnimating()
                    self.activityLabel.alpha = 0
                    self.activityView.alpha = 0
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                    self.presentViewController(welcome, animated: false, completion: nil)
                    
                }
                else {
                    
                    self.activityIndicator.stopAnimating()
                    self.activityLabel.alpha = 0
                    self.activityView.alpha = 0
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        errorMessage = errorString
                    }
                    
                    self.displayAlert("Failed login", message: errorMessage)
                }
            }
        }
    }
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        
        let signUp = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.presentViewController(signUp, animated: false, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    
    func goToCommandCentral() {
        
        let container = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        self.presentViewController(container, animated: false, completion: nil)
        
    }
    
}
