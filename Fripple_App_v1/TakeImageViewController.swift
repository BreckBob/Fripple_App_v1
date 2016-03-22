//
//  TakeImageViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 2/16/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class TakeImageViewController: UIViewController {
    
    var surveyIdSelected:String!
    @IBOutlet weak var surveyQuestion: UITextView!
    @IBOutlet weak var answerImage1: UIImageView!
    @IBOutlet weak var answerImage2: UIImageView!
    @IBOutlet weak var answerImage3: UIImageView!
    @IBOutlet weak var answerImage4: UIImageView!
    @IBOutlet weak var imageCircle1: UIImageView!
    @IBOutlet weak var imageCircle2: UIImageView!
    @IBOutlet weak var imageCircle3: UIImageView!
    @IBOutlet weak var imageCircle4: UIImageView!
    @IBOutlet weak var numberOfContacts: UILabel!
    var images = [UIImageView]()
    var number = 0
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
        
        images = [answerImage1, answerImage2, answerImage3, answerImage4]

        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        self.surveyQuestion.layer.cornerRadius = 5
        self.surveyQuestion.layer.borderWidth = 2
        self.surveyQuestion.layer.borderColor = borderColor.CGColor
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        loadData()
        
        //Add the tap gesture to select text option 1
        self.tapAnswer1.addTarget(self, action: "tappedAnswer1")
        self.imageCircle1.addGestureRecognizer(tapAnswer1)
        self.imageCircle1.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 2
        self.tapAnswer2.addTarget(self, action: "tappedAnswer2")
        self.imageCircle2.addGestureRecognizer(tapAnswer2)
        self.imageCircle2.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 3
        self.tapAnswer3.addTarget(self, action: "tappedAnswer3")
        self.imageCircle3.addGestureRecognizer(tapAnswer3)
        self.imageCircle3.userInteractionEnabled = true
        
        //Add the tap gesture to select text option 4
        self.tapAnswer4.addTarget(self, action: "tappedAnswer4")
        self.imageCircle4.addGestureRecognizer(tapAnswer4)
        self.imageCircle4.userInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func loadData() {
        
        if ((PFUser.currentUser()) != nil) {
            
            let findSurveyData:PFQuery = PFQuery(className: "Survey")
            findSurveyData.whereKey("objectId", equalTo: self.surveyIdSelected)
            findSurveyData.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    for object in objects! {
                        let questionText = object.objectForKey("question") as! String
                        self.surveyQuestion.text = questionText
                        let numberOfContactsSentTo = object.objectForKey("surveyTo") as! NSMutableArray
                        self.numberOfContacts.text = "\(numberOfContactsSentTo.count)"
                        
                        for image in self.images {
                            self.number++
                            if let questionImageFile = object.objectForKey("answerImage\(self.number)") as? PFFile {
                                questionImageFile.getDataInBackgroundWithBlock {(imageData, error) -> Void in
                                    if error == nil {
                                        image.layer.masksToBounds = false
                                        image.layer.cornerRadius = 30
                                        image.clipsToBounds = true
                                        image.layer.borderWidth = 5
                                        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
                                        image.layer.borderColor = borderColor.CGColor
                                        image.contentMode = .ScaleAspectFill
                                        
                                        image.image = UIImage(data: imageData!, scale: 2.0)
                                    }
                                }
                            }
                            else {
                                image.alpha = 0
                                
                                if self.answerImage3.alpha == 0 {
                                    self.imageCircle3.alpha = 0
                                }
                                if self.answerImage4.alpha == 0 {
                                    self.imageCircle4.alpha = 0
                                }
                            }
                        }
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
    
    func tappedAnswer1() {
        
        self.selectedAnswer = 1
        
        self.imageCircle1.image = UIImage(named: "Ripple_selected")
        self.imageCircle2.image = UIImage(named: "Ripple")
        self.imageCircle3.image = UIImage(named: "Ripple")
        self.imageCircle4.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer2() {
        
        self.selectedAnswer = 2
        
        self.imageCircle1.image = UIImage(named: "Ripple")
        self.imageCircle2.image = UIImage(named: "Ripple_selected")
        self.imageCircle3.image = UIImage(named: "Ripple")
        self.imageCircle4.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer3() {
        
        self.selectedAnswer = 3
        
        self.imageCircle1.image = UIImage(named: "Ripple")
        self.imageCircle2.image = UIImage(named: "Ripple")
        self.imageCircle3.image = UIImage(named: "Ripple_selected")
        self.imageCircle4.image = UIImage(named: "Ripple")
        
    }
    
    func tappedAnswer4() {
        
        self.selectedAnswer = 4
        
        self.imageCircle1.image = UIImage(named: "Ripple")
        self.imageCircle2.image = UIImage(named: "Ripple")
        self.imageCircle3.image = UIImage(named: "Ripple")
        self.imageCircle4.image = UIImage(named: "Ripple_selected")
        
    }
    
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
                results["question"] = self.surveyQuestion.text
                
                let imageData1 = UIImagePNGRepresentation(self.answerImage1.image!)
                let imageFile1 = PFFile(name: "image.png", data: imageData1!)
                results["answerImage1"] = imageFile1
                
                let imageData2 = UIImagePNGRepresentation(self.answerImage2.image!)
                let imageFile2 = PFFile(name: "image.png", data: imageData2!)
                results["answerImage2"] = imageFile2

                if self.answerImage3.image != nil {
                    let imageData3 = UIImagePNGRepresentation(self.answerImage3.image!)
                    let imageFile3 = PFFile(name: "image.png", data: imageData3!)
                    results["answerImage3"] = imageFile3
                }
                
                if self.answerImage4.image != nil {
                    let imageData4 = UIImagePNGRepresentation(self.answerImage4.image!)
                    let imageFile4 = PFFile(name: "image.png", data: imageData4!)
                    results["answerImage4"] = imageFile4
                }
                
                results["answerSelected"] = self.selectedAnswer
                
                results["surveyTypeText"] = "Image"
                
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
