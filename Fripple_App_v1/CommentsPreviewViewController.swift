//
//  CommentsPreviewViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 3/22/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class CommentsPreviewViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton.layer.cornerRadius = 7
        self.backButton.titleLabel?.textAlignment = .Center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
        self.presentViewController(welcome, animated: false, completion: nil)
        
    }

}
