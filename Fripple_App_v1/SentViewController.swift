//
//  SentViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/6/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class SentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var sentTableView: UITableView!
    let transitionManager = TransitionManager()
    var surveyData:NSMutableArray = NSMutableArray()
    var surveyType:String!
    var surveyID:String!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!

    override func viewDidAppear(animated: Bool) {
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sentTableView.delegate = self
        self.sentTableView.dataSource = self
        
        self.surveyData.removeAllObjects()
        self.loadData()
        
        self.sentTableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyData.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SentTableViewCell
        
        let surveyInfo:PFObject = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.questionTextView.text = (surveyInfo.objectForKey("question") as! String)
        cell.questionTextView.font = UIFont(name: "Gill Sans", size: 14)
        cell.questionTextView.textColor = UIColor.darkGrayColor()
        
        let pfimage = (surveyInfo.objectForKey("surveyType") as! PFFile)
        pfimage.getDataInBackgroundWithBlock({
            (result, error) in
            
            cell.surveyType.image = UIImage(data: result!, scale: 2.0)
        })
        
        let contacts:PFObject = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        let parseContacts = contacts.objectForKey("surveyTo") as! NSMutableArray
        if parseContacts.count == 1 {
            
            cell.numberOfContactsLabel.text = String(format: "Sent to %i friend", parseContacts.count)
            
        }
        else { cell.numberOfContactsLabel.text = String(format: "Sent to %i friends", parseContacts.count) }
        
        let dataFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd-yyyy"
        cell.timeStampLabel.text = dataFormatter.stringFromDate(surveyInfo.createdAt!)
        
        let surveyIdentifier = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        let surveyObjectId = surveyIdentifier.objectId! as String
        
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
                
                    if resultsData.count == 0
                    {
                        cell.seeResults.text = "No Results"
                        
                    }
                    else {
                        cell.seeResults.text = "See Results"
                        
                    }
            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Keep track of which survey user selected
        let surveyInfo = self.surveyData.objectAtIndex(indexPath.row) as! PFObject
        self.surveyType = (surveyInfo.objectForKey("surveyTypeText") as! String)
        self.surveyID = surveyInfo.objectId! as String
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)! as! SentTableViewCell
        
        if self.surveyType == "Text" && selectedCell.seeResults.text == "See Results" {
            self.performSegueWithIdentifier("TextResultsSegue", sender: self)
        }
        
        if self.surveyType == "Image" && selectedCell.seeResults.text == "See Results" {
            self.performSegueWithIdentifier("ImageResultsSegue", sender: self)
        }
        
        if self.surveyType == "Precanned" && selectedCell.seeResults.text == "See Results" {
            self.performSegueWithIdentifier("PrecannedResultsSegue", sender: self)
        }
        
    }
    
    func loadData() {
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if ((PFUser.currentUser()) != nil) {
            
            let findSurveyData:PFQuery = PFQuery(className: "Survey")
            findSurveyData.whereKey("surveyFrom", equalTo: PFUser.currentUser()!.objectForKey("realName")!)
            findSurveyData.orderByDescending("createdAt")
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
                        
                        self.sentTableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "TextResultsSegue") {
            
            let toTextResultsViewController = segue.destinationViewController as! TextResultsViewController
            toTextResultsViewController.surveyIdSelected = surveyID
        }
        if (segue.identifier == "ImageResultsSegue") {
            
            let toImageResultsViewController = segue.destinationViewController as! ImageResultsViewController
            toImageResultsViewController.surveyIdSelected = surveyID
            
        }
        if (segue.identifier == "PrecannedResultsSegue") {
            
            let toPrecannedResultsViewController = segue.destinationViewController as! PrecannedResultsViewController
            toPrecannedResultsViewController.surveyIdSelected = surveyID
            
        }
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
    }
    
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
            
            self.sentTableView.reloadData()
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
        self.sentTableView.reloadData()
        refreshControl.endRefreshing()
    }
}
