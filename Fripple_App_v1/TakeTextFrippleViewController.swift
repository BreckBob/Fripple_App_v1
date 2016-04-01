//
//  TakeTextFrippleViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 2/11/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class TakeTextFrippleViewController: UIViewController, UITextFieldDelegate {
    
    var surveyIdSelected:String!
    @IBOutlet weak var surveyQuestion: UITextView!
    @IBOutlet weak var anotherSurveyQuestion: UITextView!
    @IBOutlet weak var addImageIcon: UIImageView!
    @IBOutlet weak var textAnswer1: UITextField!
    @IBOutlet weak var textAnswer2: UITextField!
    @IBOutlet weak var textAnswer3: UITextField!
    @IBOutlet weak var textAnswer4: UITextField!
    @IBOutlet weak var textCircle1: UIImageView!
    @IBOutlet weak var textCircle2: UIImageView!
    @IBOutlet weak var textCircle3: UIImageView!
    @IBOutlet weak var textCircle4: UIImageView!
    @IBOutlet weak var textOptionsView: UIView!
    @IBOutlet weak var numberOfContacts: UILabel!
    var textFields = [UITextField]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    let tapAnswer1 = UITapGestureRecognizer()
    let tapAnswer2 = UITapGestureRecognizer()
    let tapAnswer3 = UITapGestureRecognizer()
    let tapAnswer4 = UITapGestureRecognizer()
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
        
        self.textOptionsView.layer.borderWidth = 2
        self.textOptionsView.layer.borderColor = borderColor.CGColor
        
        textFields = [textAnswer1, textAnswer2, textAnswer3, textAnswer4]
        
        for textField in textFields {
            
            textField.delegate = self
            
            textField.layer.cornerRadius = 5
            textField.layer.borderWidth = 3.0
            let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            textField.layer.borderColor = borderColor.CGColor
            let paddingView = UIView(frame: CGRectMake(0, 0, 5, textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = UITextFieldViewMode.Always
        }
        
        self.anotherSurveyQuestion.alpha = 0
        self.surveyQuestion.alpha = 0
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        //Upload data from parse
        loadData()
        
        //Add the tap gesture to select text option 1
        self.tapAnswer1.addTarget(self, action: "tappedAnswer1")
        self.textCircle1.addGestureRecognizer(tapAnswer1)
        self.textCircle1.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 2
        self.tapAnswer2.addTarget(self, action: "tappedAnswer2")
        self.textCircle2.addGestureRecognizer(tapAnswer2)
        self.textCircle2.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 3
        self.tapAnswer3.addTarget(self, action: "tappedAnswer3")
        self.textCircle3.addGestureRecognizer(tapAnswer3)
        self.textCircle3.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 4
        self.tapAnswer4.addTarget(self, action: "tappedAnswer4")
        self.textCircle4.addGestureRecognizer(tapAnswer4)
        self.textCircle4.userInteractionEnabled = true
        
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
                        let answer1 = object.objectForKey("answer1") as! String
                        let answer2 = object.objectForKey("answer2") as! String
                        let answer3 = object.objectForKey("answer3") as! String
                        let answer4 = object.objectForKey("answer4") as! String
                        self.textAnswer1.text = answer1
                        self.textAnswer2.text = answer2
                        
                        if answer3 != "" {
                            
                            self.textAnswer3.text = answer3
                        }
                        else {
                            self.textAnswer3.alpha = 0
                            self.textCircle3.alpha = 0
                        }
                        if answer4 != "" {
                            
                            self.textAnswer4.text = answer4
                        }
                        else {
                            self.textAnswer4.alpha = 0
                            self.textCircle4.alpha = 0
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
        
        self.textCircle1.image = UIImage(named: "Ripple_selected")
        self.textCircle2.image = UIImage(named: "Ripple")
        self.textCircle3.image = UIImage(named: "Ripple")
        self.textCircle4.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer2() {
        
        self.selectedAnswer = 2
        
        self.textCircle1.image = UIImage(named: "Ripple")
        self.textCircle2.image = UIImage(named: "Ripple_selected")
        self.textCircle3.image = UIImage(named: "Ripple")
        self.textCircle4.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer3() {
        
        self.selectedAnswer = 3
        
        self.textCircle1.image = UIImage(named: "Ripple")
        self.textCircle2.image = UIImage(named: "Ripple")
        self.textCircle3.image = UIImage(named: "Ripple_selected")
        self.textCircle4.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer4() {
        
        self.selectedAnswer = 4
        
        self.textCircle1.image = UIImage(named: "Ripple")
        self.textCircle2.image = UIImage(named: "Ripple")
        self.textCircle3.image = UIImage(named: "Ripple")
        self.textCircle4.image = UIImage(named: "Ripple_selected")
        
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
                
                results["textAnswer1"] = self.textAnswer1.text
                results["textAnswer2"] = self.textAnswer2.text
                results["textAnswer3"] = self.textAnswer3.text
                results["textAnswer4"] = self.textAnswer4.text
                
                results["answerSelected"] = self.selectedAnswer
                
                results["surveyTypeText"] = "Text"
                
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
