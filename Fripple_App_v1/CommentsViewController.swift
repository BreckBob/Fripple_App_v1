//
//  CommentsViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 3/7/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import Parse

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    var commentData = NSMutableArray()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    var surveyId:String!
    var presentingView:String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var commentsStatusLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTwo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentsStatusLabel.alpha = 0
        
        if self.presentingView == "Recieved" {
            self.backButton.alpha = 0
        }
        else {
            self.backButtonTwo.alpha = 0
        }
        
        messageTableView.backgroundColor = UIColor(red: 246/255, green: 245/255, blue: 245/255, alpha: 1)

        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        self.messageTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentsViewController.tableViewTapped))
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        self.retrieveComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
    
        dismissViewControllerAnimated(false, completion: nil)
    
    }
    
    func tableViewTapped() {
        
        self.messageTextField.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.dockViewHeightConstraint.constant = 320
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell")! as UITableViewCell
        
        let commentInfo = self.commentData.objectAtIndex(indexPath.row) as! PFObject
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        let image = UIImage(named: "Quesiton_background")
        imageView.image = image
        cell.backgroundView = imageView
        
        let dataFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd-yyyy h:mm a"
        let formattedDate = dataFormatter.stringFromDate(commentInfo.createdAt!)
        
        cell.textLabel?.text = (commentInfo.objectForKey("Text") as! String)
        
        cell.detailTextLabel?.text = "From: \(commentInfo.objectForKey("Poster") as! String) on \(formattedDate)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.commentData.count
        
    }
    
    //Post the comment
    @IBAction func postButtonTapped(sender: AnyObject) {
        
        self.messageTextField.endEditing(true)
        self.messageTextField.enabled = false
        self.postButton.enabled = false
        
        let newComment = PFObject(className: "Comment")
        
        newComment["Text"] = self.messageTextField.text
        newComment["Poster"] = PFUser.currentUser()!.objectForKey("realName")
        newComment["surveyId"] = self.surveyId
        
        newComment.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if error == nil {
                self.retrieveComments()
            }
            else {
                NSLog((error?.description)!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.messageTextField.enabled = true
                self.postButton.enabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    //Parse query to get comments for the specific fripple
    func retrieveComments () {
        
        self.hiddenView.alpha = 1
        
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        let query = PFQuery(className: "Comment")
        query.orderByDescending("createdAt")
        query.whereKey("surveyId", equalTo: self.surveyId)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            self.commentData = NSMutableArray()
            
            if error == nil {
                
                for object in objects! {
                    self.commentData.addObject(object)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.commentData.count == 0 {
                        self.commentsStatusLabel.alpha = 1
                    }
                    
                    if self.commentData.count > 0 {
                        self.commentsStatusLabel.alpha = 0
                    }
                    
                    self.hiddenView.alpha = 0
                    
                    self.activityIndicator.stopAnimating()
                    self.activityLabel.alpha = 0
                    self.activityView.alpha = 0
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.messageTableView.reloadData()
                }
            }
        })
    }
    
}
