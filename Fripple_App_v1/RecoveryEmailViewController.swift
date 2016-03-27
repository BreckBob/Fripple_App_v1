//
//  RecoveryEmailViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 3/20/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class RecoveryEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var recoverButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up the formats for the view controller
        self.emailField.delegate = self
        
        self.emailField.layer.cornerRadius = 5
        self.emailField.layer.borderWidth = 3.0
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.emailField.layer.borderColor = borderColor.CGColor
        self.emailField.leftViewMode = UITextFieldViewMode.Always
        
        self.recoverButton.layer.cornerRadius = 7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recoverButtonTapped(sender: AnyObject) {
    
        let userEmail = self.emailField.text
        
        //Request email reset from parse. If its succesfull, an email will be sent to the email address. If not, an error is presented
        PFUser.requestPasswordResetForEmailInBackground(userEmail!) { (success, error) -> Void in
            
            if(success)
            {
                let successMessage = "An email message was sent to you at \(userEmail!)"
                self.displayMessage(successMessage)
                return
            }
        
            if(error != nil)
            {
                let errorMessage = error!.userInfo["error"] as! String
                self.displayMessage(errorMessage)
            }
        }
    }
    
    func displayMessage(theMessage:String) {
        
        //Display alert message with confirmation
        let myAlert = UIAlertController(title: "Alert", message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }

}
