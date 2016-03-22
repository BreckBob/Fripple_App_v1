//
//  RecoveryEmailViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 3/20/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class RecoveryEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var recoverButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        
        self.emailField.layer.cornerRadius = 5
        self.emailField.layer.borderWidth = 3.0
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.emailField.layer.borderColor = borderColor.CGColor
        self.emailField.leftViewMode = UITextFieldViewMode.Always
        
        self.recoverButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}
