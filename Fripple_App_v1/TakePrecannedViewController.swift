//
//  TakePrecannedViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 2/18/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class TakePrecannedViewController: UIViewController {
    
    var surveyIdSelected:String!
    @IBOutlet weak var surveyQuestion: UITextView!
    @IBOutlet weak var anotherSurveyQuestion: UITextView!
    @IBOutlet weak var addImageIcon: UIImageView!
    @IBOutlet weak var numberOfContacts: UILabel!
    @IBOutlet weak var precannedCircle1: UIImageView!
    @IBOutlet weak var precannedCircle2: UIImageView!
    @IBOutlet weak var precannedCircle3: UIImageView!
    @IBOutlet weak var precannedOptionsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    let tapAnswer1 = UITapGestureRecognizer()
    let tapAnswer2 = UITapGestureRecognizer()
    let tapAnswer3 = UITapGestureRecognizer()
    var selectedAnswer = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up formats for view and load fripple data
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        self.surveyQuestion.layer.cornerRadius = 5
        self.surveyQuestion.layer.borderWidth = 2
        self.surveyQuestion.layer.borderColor = borderColor.CGColor
        
        self.anotherSurveyQuestion.layer.cornerRadius = 5
        self.anotherSurveyQuestion.layer.borderWidth = 2
        self.anotherSurveyQuestion.layer.borderColor = borderColor.CGColor
        
        self.precannedOptionsView.layer.borderWidth = 2
        self.precannedOptionsView.layer.borderColor = borderColor.CGColor
        
        self.anotherSurveyQuestion.alpha = 0
        self.surveyQuestion.alpha = 0
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        loadData()
        
        //Add the tap gesture to select text option 1
        self.tapAnswer1.addTarget(self, action: "tappedAnswer1")
        self.precannedCircle1.addGestureRecognizer(tapAnswer1)
        self.precannedCircle1.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 2
        self.tapAnswer2.addTarget(self, action: "tappedAnswer2")
        self.precannedCircle2.addGestureRecognizer(tapAnswer2)
        self.precannedCircle2.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 3
        self.tapAnswer3.addTarget(self, action: "tappedAnswer3")
        self.precannedCircle3.addGestureRecognizer(tapAnswer3)
        self.precannedCircle3.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    //Code to get data from parse 
    func loadData() {
        
        if ((PFUser.currentUser()) != nil) {
            
            let findSurveyData:PFQuery = PFQuery(className: "Survey")
            findSurveyData.whereKey("objectId", equalTo: self.surveyIdSelected)
            findSurveyData.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    for object in objects! {
                        let questionText = object.objectForKey("question") as! String
                        self.surveyQuestion.text = questionText
                        
                        if let questionImageFile = object.objectForKey("mainImageFile") as? PFFile {
                            questionImageFile.getDataInBackgroundWithBlock {(imageData, error) -> Void in
                                if error == nil {
                                    self.surveyQuestion.alpha = 1
                                    self.surveyQuestion.text = questionText
                                    
                                    self.addImageIcon.layer.masksToBounds = false
                                    self.addImageIcon.layer.cornerRadius = 45
                                    self.addImageIcon.clipsToBounds = true
                                    self.addImageIcon.layer.borderWidth = 5
                                    let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
                                    self.addImageIcon.layer.borderColor = borderColor.CGColor
                                    self.addImageIcon.contentMode = .ScaleAspectFill
                                    
                                    self.addImageIcon.image = UIImage(data: imageData!, scale: 2.0)
                                }
                            }
                        }
                        else {
                            self.anotherSurveyQuestion.alpha = 1
                            self.anotherSurveyQuestion.text = questionText
                        }
                        
                        let numberOfContactsSentTo = object.objectForKey("surveyTo") as! NSMutableArray
                        self.numberOfContacts.text = "\(numberOfContactsSentTo.count)"
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicator.stopAnimating()
                        self.activityLabel.alpha = 0
                        self.activityView.alpha = 0
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    }
                }
            })
        }
    }
    //Code when user selects their answer to change image
    func tappedAnswer1() {
        
        self.selectedAnswer = 1
        
        self.precannedCircle1.image = UIImage(named: "Ripple_selected")
        self.precannedCircle2.image = UIImage(named: "Ripple")
        self.precannedCircle3.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer2() {
        
        self.selectedAnswer = 2
        
        self.precannedCircle1.image = UIImage(named: "Ripple")
        self.precannedCircle2.image = UIImage(named: "Ripple_selected")
        self.precannedCircle3.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer3() {
        
        self.selectedAnswer = 3
        
        self.precannedCircle1.image = UIImage(named: "Ripple")
        self.precannedCircle2.image = UIImage(named: "Ripple")
        self.precannedCircle3.image = UIImage(named: "Ripple_selected")
        
    }
    
    //Submit the users answers to parse
    @IBAction func submitButtonTapped(sender: AnyObject) {
        
        if self.selectedAnswer != 0 {
            
            if ((PFUser.currentUser()) != nil) {
                self.activityIndicator.startAnimating()
                self.activityLabel.alpha = 1
                self.activityView.alpha = 1
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                //Upload text or image answer options and answer selected to parse
                let results = PFObject(className: "Results")
                results["surveyTaker"] = PFUser.currentUser()
                results["surveyId"] = self.surveyIdSelected
                
                if self.surveyQuestion.text != "" {
                    results["question"] = self.surveyQuestion.text
                }
                else {
                    results["question"] = self.anotherSurveyQuestion.text
                }
                
                if self.addImageIcon.image != nil {
                    
                    let imageData = UIImagePNGRepresentation(self.addImageIcon.image!)
                    let imageFile = PFFile(name: "image.png", data: imageData!)
                    results["mainImageFile"] = imageFile
                    
                }
                
                results["answerSelected"] = self.selectedAnswer
                
                results["surveyTypeText"] = "Precanned"
                
                results.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                    if error == nil {
                        self.activityIndicator.stopAnimating()
                        self.activityLabel.alpha = 0
                        self.activityView.alpha = 0
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        let alert = UIAlertController(title: "Fripple submitted", message: "Your response has been saved", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Great thanks", style: .Default, handler: { (action) -> Void in
                            let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                            self.presentViewController(welcome, animated: false, completion: nil)
                        }))
                        self.presentViewController(alert, animated: false, completion: nil)
                        
                    }
                    else {
                        self.displayAlert("Could not send Fripple", message: "Please try again")
                    }
                    
                })
            }
        }
        else {
            displayAlert("Choose an option", message: "You need to make a selection to submit the Fripple")
        }
    }
    
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it thanks", style: .Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
}
