//
//  SignUpViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/13/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import MessageUI

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    let permissions = ["public_profile"]
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the format for the view
        self.name.delegate = self
        self.mobile.delegate = self
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
        

        self.name.layer.cornerRadius = 5
        self.name.layer.borderWidth = 2
        
        self.mobile.layer.cornerRadius = 5
        self.mobile.layer.borderWidth = 2
        
        self.username.layer.cornerRadius = 5
        self.username.layer.borderWidth = 2
        
        self.email.layer.cornerRadius = 5
        self.email.layer.borderWidth = 2
        
        self.password.layer.cornerRadius = 5
        self.password.layer.borderWidth = 2
        
        self.repeatPassword.layer.cornerRadius = 5
        self.repeatPassword.layer.borderWidth = 2
        
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.name.layer.borderColor = borderColor.CGColor
        self.mobile.layer.borderColor = borderColor.CGColor
        self.username.layer.borderColor = borderColor.CGColor
        self.email.layer.borderColor = borderColor.CGColor
        self.password.layer.borderColor = borderColor.CGColor
        self.repeatPassword.layer.borderColor = borderColor.CGColor
        
        self.activityView.layer.cornerRadius = 10
        self.activityLabel.alpha = 0
        self.activityView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signUp(sender: AnyObject) {
        
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        //Code to reformat phone number to only numbers
        let orginalMobileNumber = mobile.text
        let newFormatedPhoneNumber = orginalMobileNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        //Check to make sure fields are completed and if not display alert
        if self.name.text!.isEmpty || self.mobile.text!.isEmpty || self.username.text!.isEmpty || self.email.text!.isEmpty || self.password.text!.isEmpty || self.repeatPassword.text!.isEmpty {
            
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            displayAlert("There was an error", message: "Please make sure all fields are filled out")
            
        }
        
        else if self.password.text != self.repeatPassword.text {
            
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            displayAlert("There was an error", message: "The passwords entered don't match, please enter again")
            
        }
        else {
            
            //check phone number alreay exists
            let results = NSMutableArray()
            let query = PFQuery(className: "_User")
            query.whereKey("phoneNumber", equalTo: newFormatedPhoneNumber)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    for object in objects! {
                        results.addObject(object)
                    }
                    
                    if (results.count != 0) {
                        self.activityIndicator.stopAnimating()
                        self.activityLabel.alpha = 0
                        self.activityView.alpha = 0
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        self.displayAlert("There was an error", message: "That phone number has already been used, please enter another one")
                    }
                    else {
                        //If everything is ok sign up user and save info to parse
                        let user = PFUser()
                        user.username = self.username.text
                        user.password = self.password.text
                        user.email = self.email.text
                        user["phoneNumber"] = newFormatedPhoneNumber
                        user["realName"] = self.name.text
                        
                        var errorMessage = "There was an error, please try again later"
                        
                        user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                            
                            self.activityIndicator.startAnimating()
                            self.activityLabel.alpha = 1
                            self.activityView.alpha = 1
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            if error == nil {
                                
                                let alert = UIAlertController(title: "Congrats", message: "Your Fripple account was created", preferredStyle: UIAlertControllerStyle.Alert)
                                
                                alert.addAction(UIAlertAction(title: "Great, thanks!", style: .Default, handler: { (action) -> Void in
                                    
                                    let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                                    self.presentViewController(welcome, animated: false, completion: nil)
                                
                                }))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                self.activityIndicator.stopAnimating()
                                self.activityLabel.alpha = 0
                                self.activityView.alpha = 0
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                
                                if let errorString = error!.userInfo["error"] as? String {
                                    errorMessage = errorString
                                }
                                
                                self.displayAlert("Failed signup", message: errorMessage)
                            }
                        })
                    }
                    
                }
            })
        }
    }
    
    @IBAction func goBackToWelcome(sender: AnyObject) {
        
        let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
        self.presentViewController(welcome, animated: false, completion: nil)
        
    }
    
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func whySignUp(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Why sign up?", message: "Signing up gives you the ability to send and recieve Fripples from friends as well as track results of Fripples sent or taken. Doesn't that sound great?!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "View Privacy Policy", style: .Default, handler: { (action) -> Void in
            let privacy = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyViewController") as! PrivacyViewController
            self.presentViewController(privacy, animated: false, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func haveAcct(sender: AnyObject) {
        
        let login = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(login, animated: false, completion: nil)
        
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
