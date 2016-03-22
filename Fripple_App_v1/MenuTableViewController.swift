//
//  MenuTableViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/4/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class MenuTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var mailComposer:MFMailComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Menus options and what to do based on each case
        switch indexPath.row {
        case 0:
            let about = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            self.presentViewController(about, animated: false, completion: nil)
        case 1:
            if MFMailComposeViewController.canSendMail(){
                mailComposer = MFMailComposeViewController()
                
                mailComposer?.mailComposeDelegate = self
                
                mailComposer?.setToRecipients(["feedback@frippleapp.com"])
                mailComposer?.setSubject("Feedback for Fripple")
                mailComposer?.setMessageBody("Please enter your feedback and/or thoughts for potential new features here.", isHTML: false)
                
                self.presentViewController(self.mailComposer!, animated: true, completion: nil)
            }
            else {
                NSLog("Device not configured for email")
            }
        case 2:
            if MFMailComposeViewController.canSendMail(){
                mailComposer = MFMailComposeViewController()
                
                mailComposer?.mailComposeDelegate = self
                
                mailComposer?.setToRecipients(["support@frippleapp.com"])
                mailComposer?.setSubject("I need help")
                mailComposer?.setMessageBody("Please describe your problem here.", isHTML: false)
                
                self.presentViewController(self.mailComposer!, animated: true, completion: nil)
            }
            else {
                NSLog("Device not configured for email")
            }
        case 3:
            let privacy = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyViewController") as! PrivacyViewController
            self.presentViewController(privacy, animated: false, completion: nil)
        case 4:
            let settings = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            self.presentViewController(settings, animated: false, completion: nil)
        case 5:
            PFUser.logOut()
            
            let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
            self.presentViewController(welcome, animated: false, completion: nil)
        default:
            print("Something broke")
        }
    }
    
    //Set up the email capabilities
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch(result) {
            
        case MFMailComposeResultSent:
            NSLog("Mail was sent")
        case MFMailComposeResultFailed:
            NSLog("Mail failed to send")
        case MFMailComposeResultSaved:
            NSLog("Mail was saved")
        default:
            NSLog("Something else happened")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
