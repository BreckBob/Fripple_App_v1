//
//  CommandCentralViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/24/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class CommandCentralViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    let transitionManager = TransitionManager()
    let transitionManagerTwo = TransitionManagerTwo()
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var surveyCount:Int = Int()
    var recievedSurveyCount:Int = Int()
    @IBOutlet weak var sentSurveyCount: UILabel!
    @IBOutlet weak var takenSurveyCount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    
    override func viewDidAppear(animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Function to get survey info
        self.surveysQuery()
        
        if PFUser.currentUser() != nil {
            
            backButton.alpha = 0
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CommandCentralViewController.swipedViewRight(_:)))
            rightSwipe.direction = .Right
            self.view.addGestureRecognizer(rightSwipe)
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CommandCentralViewController.swipedViewLeft(_:)))
            leftSwipe.direction = .Left
            self.view.addGestureRecognizer(leftSwipe)
            
        }
        
        if PFUser.currentUser() == nil {
            menuButton.alpha = 0
            backButton.alpha = 1
        }
        
        activityView.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func create(sender: AnyObject) {
        self.mainImage.image = UIImage(named: "Full_circle_grey")
        delay(0.1) {
            let new = self.storyboard?.instantiateViewControllerWithIdentifier("NewFrippleViewController") as! NewFrippleViewController
            new.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(new, animated: false, completion: nil)
            
            self.mainImage.image = UIImage(named: "Full_circle")
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func leftView(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenuLeft", object: nil)
    }
    
    func swipedViewRight(sender: UISwipeGestureRecognizer) {
        NSNotificationCenter.defaultCenter().postNotificationName("swipedRight", object: nil)
    }
    
    func swipedViewLeft(sender: UISwipeGestureRecognizer) {
        NSNotificationCenter.defaultCenter().postNotificationName("swipedLeft", object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "RecievedSegue" {
            if takenSurveyCount.text != "0" {
                // this gets a reference to the screen that we're about to transition to
                let toViewController = segue.destinationViewController
                
                // instead of using the default transition animation, we'll ask
                // the segue to use our custom TransitionManager object to manage the transition animation
                toViewController.transitioningDelegate = self.transitionManager
            }
            else {
                displayAlert("Whoa, slow down there skip", message: "You haven't recieved a Fripple yet. But, you can tap \"Create\" to send one to a friend")
            }
        }
        if segue.identifier == "SentSegue" {
            if sentSurveyCount.text != "0" {
                // this gets a reference to the screen that we're about to transition to
                let toViewController = segue.destinationViewController
                
                // instead of using the default transition animation, we'll ask
                // the segue to use our custom TransitionManager object to manage the transition animation
                toViewController.transitioningDelegate = self.transitionManagerTwo
            }
            else {
                displayAlert("Whoa, slow down there happy fingers", message: "You haven't created a Fripple yet. Tap \"Create\" to do so")
            }

        }
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
        self.presentViewController(welcome, animated: false, completion: nil)
        
    }
    
    func surveysQuery() {
        
        if ((PFUser.currentUser()) != nil) {
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            let query = PFQuery(className: "Survey")
            query.whereKey("surveyFrom", equalTo: PFUser.currentUser()!.objectForKey("realName")!)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    //The find succeeded. Get count of surveys
                    let surveyCount = objects!.count as Int!
                    self.sentSurveyCount.text = String(format: "%i", surveyCount)
                }
                else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error!, error!.userInfo) }
            })
        }
        
        if ((PFUser.currentUser()) != nil) {
            
            let query = PFQuery(className: "Survey")
            query.whereKey("surveyToPhoneNumbers", equalTo: PFUser.currentUser()!.objectForKey("phoneNumber")!)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    //The find succeeded. Get count of surveys
                    let surveyCount = objects!.count as Int!
                    self.takenSurveyCount.text = String(format: "%i", surveyCount)
                }
                else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error!, error!.userInfo)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.activityIndicator.stopAnimating()
                    self.activityLabel.alpha = 0
                    self.activityView.alpha = 0
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }
            })
        }
        
        if ((PFUser.currentUser()) == nil) {
            
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            
            self.takenSurveyCount.text = "0"
            self.sentSurveyCount.text = "0"
            
        }
        
    }
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it thanks", style: .Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
}