//
//  AboutViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/28/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeButton(sender: AnyObject) {
        
        //Go back to the container view
        let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        self.presentViewController(welcome, animated: false, completion: nil)
        
    }
    
}
