//
//  ImageResultsViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 2/23/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class ImageResultsViewController: UIViewController {
    
    var surveyIdSelected:String!
    @IBOutlet weak var surveyQuestion: UITextView!
    @IBOutlet weak var answerImage1: UIImageView!
    @IBOutlet weak var answerImage2: UIImageView!
    @IBOutlet weak var answerImage3: UIImageView!
    @IBOutlet weak var answerImage4: UIImageView!
    var images = [UIImageView]()
    var number = 0
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var answerCircle1: UIImageView!
    @IBOutlet weak var answerCircle2: UIImageView!
    @IBOutlet weak var answerCircle3: UIImageView!
    @IBOutlet weak var answerCircle4: UIImageView!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var surveysSentLabel: UILabel!
    
    var surveysSent: NSMutableArray!
    var responseCount:Int!
    var answer1Array = NSMutableArray()
    var answer2Array = NSMutableArray()
    var answer3Array = NSMutableArray()
    var answer4Array = NSMutableArray()
    
    override func viewDidAppear(animated: Bool) {
        self.retrieveComments()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout formats for answer options
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
                        if answerResponse == 4 {
                            
                            self.answer4Array.addObject(answerResponse)
                            
                        }
                        
                        let questionText = object.objectForKey("question") as! String
                        self.surveyQuestion.text = questionText
                        
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
                                    self.answerCircle3.alpha = 0
                                }
                                if self.answerImage4.alpha == 0 {
                                    self.answerCircle4.alpha = 0
                                }
                            }
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
                        
                        let response4Percent = Float(self.answer4Array.count) / Float(self.responseCount) * 100
                        let response4Int = Int(response4Percent)
                        self.answerCircle4.image = UIImage(named: ("Result_\(response4Int)_grey"))
                        
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
        
    }
    
}
