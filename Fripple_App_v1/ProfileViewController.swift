//
//  ProfileViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 3/11/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    var infoFields = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up formats for view
        self.name.delegate = self
        self.mobile.delegate = self
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self

        infoFields = [name, mobile, username, email, password, repeatPassword]
        
        for info in infoFields {
            
            info.delegate = self
            
            info.layer.cornerRadius = 5
            info.layer.borderWidth = 3.0
            let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            info.layer.borderColor = borderColor.CGColor
            info.leftViewMode = UITextFieldViewMode.Always
        }
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.updateButton.enabled = false
        
        self.loadUserInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    @IBAction func editProfileInfo(sender: AnyObject) {
        
        let myUser = PFUser.currentUser()
        
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        //Check to see if any fields are empty and if so display alert
        if (self.name.text!.isEmpty || self.mobile.text!.isEmpty || self.username.text!.isEmpty || self.email.text!.isEmpty) {
            
            self.stopIndicator()
            
            self.displayAlert("There was an error", message: "Please make sure all fields contain info")
        }
        
        //Confirm passwords match
        if (!self.password.text!.isEmpty && (self.password.text != repeatPassword.text)) {
            
            self.stopIndicator()
            
            self.displayAlert("There was an error", message: "Passwords don't match")
            
        }
        
        let userName = self.name.text
        let userMobile = self.mobile.text
        let userUsername = self.username.text
        let userEmail = self.email.text
        //If all fields are completed update info to parse
        myUser!.setObject(userName!, forKey: "realName")
        myUser!.setObject(userMobile!, forKey: "phoneNumber")
        myUser!.setObject(userUsername!, forKey: "username")
        myUser!.setObject(userEmail!, forKey: "email")
        
        if (!self.password.text!.isEmpty) {
            
            let userPassword = self.password.text
            myUser!.password = userPassword
        }
        
        myUser!.saveInBackgroundWithBlock({ (success, error) -> Void in
            
            self.stopIndicator()
            
            if (error != nil) {
                self.displayAlert("There was an error", message: error!.localizedDescription)
            }
            
            if (success) {
                //If info updated successfully display alert
                let alert = UIAlertController(title: "Success", message: "Profile details successfully updated", preferredStyle: UIAlertControllerStyle.Alert)
                
                self.activityIndicator.startAnimating()
                self.activityLabel.alpha = 1
                self.activityView.alpha = 1
                
                alert.addAction(UIAlertAction(title: "Great, thanks!", style: .Default, handler: { (action) -> Void in
                    
                    if (!self.password.text!.isEmpty) {
                        //If the user changed thier password, log them out and send them to the main login page
                        
                        PFUser.logOut()
                        
                        let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
                        self.presentViewController(welcome, animated: false, completion: nil)
                    }
                    else {
                        //If the user didn't change their password send them to command center
                        let container = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                        self.presentViewController(container, animated: false, completion: nil)
                    }
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
        self.updateButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        self.updateButton.enabled = true
        
        return false
    }
    
    func loadUserInfo() {
        
        //Load user details
        let query = PFUser.currentUser()
        let infoName = query!.objectForKey("realName") as! String
        let infoMobile = query!.objectForKey("phoneNumber") as! String
        let infoUserName = query!.objectForKey("username") as! String
        let infoEmail = query!.objectForKey("email") as! String
        self.name.text = infoName
        self.mobile.text = infoMobile
        self.username.text = infoUserName
        self.email.text = infoEmail
        
        stopIndicator()
        
    }
        
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func stopIndicator() {
    
        self.activityIndicator.stopAnimating()
        self.activityLabel.alpha = 0
        self.activityView.alpha = 0
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    
    }
    
}
