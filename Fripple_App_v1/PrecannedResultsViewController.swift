//
//  PrecannedResultsViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 2/23/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class PrecannedResultsViewController: UIViewController {
    
    var surveyIdSelected:String!
    @IBOutlet weak var surveyQuestion: UITextView!
    @IBOutlet weak var anotherSurveyQuestion: UITextView!
    @IBOutlet weak var addImageIcon: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var answerCircle1: UIImageView!
    @IBOutlet weak var answerCircle2: UIImageView!
    @IBOutlet weak var answerCircle3: UIImageView!
    @IBOutlet weak var PrecannedOptionsView: UIView!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var surveysSentLabel: UILabel!
    
    var surveysSent: NSMutableArray!
    var responseCount:Int!
    var answer1Array = NSMutableArray()
    var answer2Array = NSMutableArray()
    var answer3Array = NSMutableArray()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTwo: UIButton!
    var viewDoingThePresenting:String?
    
    override func viewDidAppear(animated: Bool) {
        self.retrieveComments()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.viewDoingThePresenting == "Recieved" {
            self.backButton.alpha = 0
        }
        else {
            self.backButtonTwo.alpha = 0
        }

        //Layout formats for answer options
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        self.surveyQuestion.layer.cornerRadius = 5
        self.surveyQuestion.layer.borderWidth = 2
        self.surveyQuestion.layer.borderColor = borderColor.CGColor
        
        self.anotherSurveyQuestion.layer.cornerRadius = 5
        self.anotherSurveyQuestion.layer.borderWidth = 2
        self.anotherSurveyQuestion.layer.borderColor = borderColor.CGColor
        
        self.PrecannedOptionsView.layer.borderWidth = 2
        self.PrecannedOptionsView.layer.borderColor = borderColor.CGColor
        
        self.anotherSurveyQuestion.alpha = 0
        self.surveyQuestion.alpha = 0
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.getResults()
        
        self.getSurveyResults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    //Parse query to get results for specific fripple
    func getResults(){
        
        if ((PFUser.currentUser()) != nil) {
            
            let query = PFQuery(className: "Results")
            query.whereKey("surveyId", equalTo: surveyIdSelected)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    
                    self.responseCount = objects!.count as Int!
                    
                    if self.responseCount == 1 {
                        self.resultsLabel.text = "\(self.responseCount) Fripple Completed"
                    }
                    else {
                        self.resultsLabel.text = "\(self.responseCount) Fripples Completed"
                    }
                    
                    for object in objects! {
                        
                        let answerResponse = object["answerSelected"] as! Int
                        
                        if answerResponse == 1 {
                            
                            self.answer1Array.addObject(answerResponse)
                            
                        }
                        if answerResponse == 2 {
                            
                            self.answer2Array.addObject(answerResponse)
                            
                        }
                        if answerResponse == 3 {
                            
                            self.answer3Array.addObject(answerResponse)
                            
                        }
                        
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
                        
                        
                        let response1Percent = Float(self.answer1Array.count) / Float(self.responseCount) * 100
                        let response1Int = Int(response1Percent)
                        self.answerCircle1.image = UIImage(named: ("Result_\(response1Int)_grey"))
                        
                        let response2Percent = Float(self.answer2Array.count) / Float(self.responseCount) * 100
                        let response2Int = Int(response2Percent)
                        self.answerCircle2.image = UIImage(named: ("Result_\(response2Int)_grey"))
                        
                        let response3Percent = Float(self.answer3Array.count) / Float(self.responseCount) * 100
                        let response3Int = Int(response3Percent)
                        self.answerCircle3.image = UIImage(named: ("Result_\(response3Int)_grey"))
                        
                    }
                }
            })
        }
    }
    
    //Parse query to count the number of fripples that have been completed and total number sent
    func getSurveyResults() {
        
        if ((PFUser.currentUser()) != nil) {
            
            let query = PFQuery(className: "Survey")
            query.getObjectInBackgroundWithId(surveyIdSelected){ (objects, error) -> Void in
                if error == nil {
                    
                    self.surveysSent = objects!.objectForKey("surveyTo") as! NSMutableArray
                    
                    if self.surveysSent.count == 1 {
                        
                        self.surveysSentLabel.text = "Out of \(self.surveysSent.count) Fripple Sent"
                        
                    }
                    else {
                        
                        self.surveysSentLabel.text = "Out of \(self.surveysSent.count) Fripples Sent"
                        
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.activityIndicator.stopAnimating()
                        self.activityLabel.alpha = 0
                        self.activityView.alpha = 0
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    }
                    
                }
                else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error!, error!.userInfo)
                }
            }
        }
    }
    
    //Parse query to get comments for the specific fripple
    func retrieveComments () {
        
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let query = PFQuery(className: "Comment")
        query.whereKey("surveyId", equalTo: self.surveyIdSelected)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error == nil {
                
                let commentCount = objects!.count as Int!
                self.numberOfComments.text = String(format: "%i", commentCount)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.activityIndicator.stopAnimating()
                self.activityLabel.alpha = 0
                self.activityView.alpha = 0
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toCommentsViewController = segue.destinationViewController as! CommentsViewController
        toCommentsViewController.surveyId = surveyIdSelected
        toCommentsViewController.presentingView = viewDoingThePresenting
    }
    
}
