//
//  PrivacyViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/22/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class PrivacyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func closeButton(sender: AnyObject) {
        
        if PFUser.currentUser() == nil {
         
            dismissViewControllerAnimated(false, completion: nil)
            
        }
        else {
            
            let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
            self.presentViewController(welcome, animated: false, completion: nil)
        
        }
    }
}
