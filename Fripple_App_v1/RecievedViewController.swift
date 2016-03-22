//
//  RecievedViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/6/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class RecievedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recievedTableView: UITableView!
    let transitionManagerTwo = TransitionManagerTwo()
    var surveyData:NSMutableArray = NSMutableArray()
    var surveyType:String!
    var surveyID:String!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make view datasource and delegate
        self.recievedTableView.delegate = self
        self.recievedTableView.dataSource = self
        
        //Remove data and reload
        self.surveyData.removeAllObjects()
        self.loadData()
        
        //Add the refresh capability
        self.recievedTableView.addSubview(self.refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return surveyData.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RecievedTableViewCell
        
        //Get survey info for specific row from parse
        let surveyInfo = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.questionTextView.text = (surveyInfo.objectForKey("question") as! String)
        cell.questionTextView.font = UIFont(name: "Gill Sans", size: 14)
        cell.questionTextView.textColor = UIColor.darkGrayColor()
        cell.questionTextView.textContainer.lineFragmentPadding = 0
        
        cell.surveySender.text = (surveyInfo.objectForKey("surveyFrom") as! String)
        
        let pfimage = (surveyInfo.objectForKey("surveyType") as! PFFile)
        pfimage.getDataInBackgroundWithBlock({
            (result, error) in
            
            cell.surveyType.image = UIImage(data: result!, scale: 2.0)
        })
        
        let dataFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd-yyyy"
        cell.timeStampLabel.text = dataFormatter.stringFromDate(surveyInfo.createdAt!)
        
        let surveyIdentifier = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        let surveyObjectId = surveyIdentifier.objectId! as String
        
        //Get results data from parse to let user know how many people have taken the fripple
        if ((PFUser.currentUser()) != nil) {
            
            let resultsData = NSMutableArray()
            
            let query = PFQuery(className: "Results")
            query.whereKey("surveyId", equalTo: surveyObjectId)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    
                    for object in objects! {
                        resultsData.addObject(object)
                    }
                    
                    cell.resultsLabel.text = "\(resultsData.count)"
                }
            })
        }
        
        //Lets the user know if they still need to take a fripple before they can see results
        if ((PFUser.currentUser()) != nil) {
            
            let resultsData = NSMutableArray()
            
            let query = PFQuery(className: "Results")
            query.whereKey("surveyTaker", equalTo: PFUser.currentUser()!)
            query.whereKey("surveyId", equalTo: surveyObjectId)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    
                    for object in objects! {
                        resultsData.addObject(object)
                    }
                    
                        if resultsData.count == 0
                        {
                            cell.takeLabel.text = "Take Fripple"
                        }
                        else { cell.takeLabel.text = "See Results" }
                }
            })
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)! as! RecievedTableViewCell
        
        let surveyInfo = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        self.surveyType = (surveyInfo.objectForKey("surveyTypeText") as! String)
        self.surveyID = surveyInfo.objectId! as String
        
        //Specific actions based on what type of fripple and if the user has taken it or not
        if self.surveyType == "Text" && selectedCell.takeLabel.text == "Take Fripple" {
            self.performSegueWithIdentifier("TakeTextSegue", sender: self)
        }
        if self.surveyType == "Text" && selectedCell.takeLabel.text == "See Results" {
            self.performSegueWithIdentifier("TextResultsSegue", sender: self)
        }
        
        if self.surveyType == "Image" && selectedCell.takeLabel.text == "Take Fripple" {
            self.performSegueWithIdentifier("TakeImageSegue", sender: self)
        }
        if self.surveyType == "Image" && selectedCell.takeLabel.text == "See Results" {
            self.performSegueWithIdentifier("ImageResultsSegue", sender: self)
        }
        
        if self.surveyType == "Precanned" && selectedCell.takeLabel.text == "Take Fripple" {
            self.performSegueWithIdentifier("TakePrecannedSegue", sender: self)
        }
        if self.surveyType == "Precanned" && selectedCell.takeLabel.text == "See Results" {
            self.performSegueWithIdentifier("PrecannedResultsSegue", sender: self)
        }
        
    }
    
    //Code to handle deleting rows
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let surveyIdentifier = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
            
            surveyIdentifier.deleteInBackground()
            
            self.surveyData.removeObjectAtIndex(indexPath.row)
            
            self.recievedTableView.reloadData()
        }
    }
    
    //Specific segues based on what type of fripple and if the user has taken it or not
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "TakeTextSegue") {
            
            let toTakeTextFrippleViewController = segue.destinationViewController as! TakeTextFrippleViewController
            toTakeTextFrippleViewController.surveyIdSelected = surveyID
        }
        if (segue.identifier == "TextResultsSegue") {
            
            let toTextResultsViewController = segue.destinationViewController as! TextResultsViewController
            toTextResultsViewController.surveyIdSelected = surveyID
        }
        if (segue.identifier == "TakeImageSegue") {
            
            let toTakeImageViewController = segue.destinationViewController as! TakeImageViewController
            toTakeImageViewController.surveyIdSelected = surveyID
            
        }
        if (segue.identifier == "ImageResultsSegue") {
            
            let toImageResultsViewController = segue.destinationViewController as! ImageResultsViewController
            toImageResultsViewController.surveyIdSelected = surveyID
        }
        if (segue.identifier == "TakePrecannedSegue") {
            
            let toTakePrecannedViewController = segue.destinationViewController as! TakePrecannedViewController
            toTakePrecannedViewController.surveyIdSelected = surveyID
        }
        if (segue.identifier == "PrecannedResultsSegue") {
            
            let toPrecannedResultsViewController = segue.destinationViewController as! PrecannedResultsViewController
            toPrecannedResultsViewController.surveyIdSelected = surveyID
            
        }
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManagerTwo
    }
    
    //Code to get survey data from parse and provide to view
    func loadData() {
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if ((PFUser.currentUser()) != nil) {
            
            let findSurveyData:PFQuery = PFQuery(className: "Survey")
            findSurveyData.orderByDescending("createdAt")
            findSurveyData.whereKey("surveyToPhoneNumbers", equalTo: PFUser.currentUser()!.objectForKey("phoneNumber")!)
            findSurveyData.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    
                    for object in objects! {
                        self.surveyData.addObject(object)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hiddenView.alpha = 0
                        
                        self.activityIndicator.stopAnimating()
                        self.activityLabel.alpha = 0
                        self.activityView.alpha = 0
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        self.recievedTableView.reloadData()
                    }
                }
            })
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.surveyData.removeAllObjects()
        self.loadData()
        self.recievedTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}
