//
//  NewFripplePrecannedViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/14/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class NewFripplePrecannedViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var precannedQuestionContainer: UITextView!
    var questionText:String!
    @IBOutlet weak var answersContainer: UIView!
    var keyboardPresent = Bool()
    var precannedContactsString:String!
    @IBOutlet weak var numberOfPrecannedContacts: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    var imageFromNewFripple:UIImage!
    var imageFromNewFrippleBool:Bool!
    var presentedVC = "Precanned"
    
    var listOfContacts = [String]()
    var listOfPhoneNumbers = [String]()
    
    let tapGesture = UITapGestureRecognizer()
    
    var preCannedImagePicked = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBAction func unwindFromContacts (sender: UIStoryboardSegue){
        self.numberOfPrecannedContacts.text = ("\(listOfContacts.count)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.precannedQuestionContainer.text = questionText
        self.numberOfPrecannedContacts.text = precannedContactsString
        
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        if imageFromNewFrippleBool == true {
            self.mainImage.layer.masksToBounds = false
            self.mainImage.layer.cornerRadius = 45
            self.mainImage.clipsToBounds = true
            self.mainImage.layer.borderWidth = 5
            self.mainImage.layer.borderColor = borderColor.CGColor
            self.mainImage.contentMode = .ScaleAspectFill
            
            self.mainImage.image = imageFromNewFripple
            self.preCannedImagePicked = true
            
        } else {
            self.mainImage.image = UIImage(named: "Circle_pic")
            self.mainImage.layer.cornerRadius = 0
            self.mainImage.layer.borderWidth = 0
            self.mainImage.layer.borderColor = nil
            self.mainImage.contentMode = .ScaleAspectFit
        }

        self.precannedQuestionContainer.delegate = self
        
        self.precannedQuestionContainer.layer.cornerRadius = 5
        self.precannedQuestionContainer.layer.borderWidth = 2
        self.precannedQuestionContainer.layer.borderColor = borderColor.CGColor
        
        self.answersContainer.layer.borderWidth = 2
        self.answersContainer.layer.borderColor = borderColor.CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        //Add the tap gesture to the main image
        tapGesture.addTarget(self, action: "tappedImportImage")
        self.mainImage.addGestureRecognizer(tapGesture)
        self.mainImage.userInteractionEnabled = true
        
        self.activityView.layer.cornerRadius = 10
        self.activityView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardPresent != true {
            self.view.frame.origin.y -= 85
        }
        
        self.keyboardPresent = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardPresent == true {
            self.view.frame.origin.y += 85
        }
        
        self.keyboardPresent = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func backToCommand(sender: AnyObject) {
        
        let command = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        self.presentViewController(command, animated: false, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "toNewImageSegue" {
            let toNewFrippleImageViewController = segue.destinationViewController as! NewFrippleImageViewController
            toNewFrippleImageViewController.questionText = precannedQuestionContainer.text
            toNewFrippleImageViewController.imageContactsString = numberOfPrecannedContacts.text
        }
        if segue.identifier == "toContacts" {
            let toContacts = segue.destinationViewController as! ContactsViewController
            toContacts.presentingView = presentedVC
        }
        if segue.identifier == "unwindToNewSurveyViewController" {
            let toNewFrippleViewController = segue.destinationViewController as! NewFrippleViewController
            toNewFrippleViewController.questionText = precannedQuestionContainer.text
            toNewFrippleViewController.textContactsString = numberOfPrecannedContacts.text
            toNewFrippleViewController.imageFromPrecannedFrippleBool = preCannedImagePicked
            toNewFrippleViewController.imageFromPrecannedFripple = mainImage.image
        }
    }
    
    
    @IBAction func clickedContacts(sender: AnyObject) {
        //Code to check if the text or image options are blank
        if self.precannedQuestionContainer.text != "" {
            performSegueWithIdentifier("toContacts", sender: sender)
                
        } else {
            displayAlert("Add question text", message: "Make sure you have at least a question asked (you can also add an image) before adding friends")
        }
    }
    
    func tappedImportImage() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [NSObject : AnyObject]!) {
        
        self.preCannedImagePicked = true
        
        self.mainImage.layer.masksToBounds = false
        self.mainImage.layer.cornerRadius = 45
        mainImage.clipsToBounds = true
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.mainImage.layer.borderWidth = 5
        self.mainImage.layer.borderColor = borderColor.CGColor
        mainImage.contentMode = .ScaleAspectFill
        mainImage.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clear(sender: AnyObject) {
        self.precannedQuestionContainer.text = ""
        
        self.preCannedImagePicked = false
        self.mainImage.image = UIImage(named: "Circle_pic")
        self.mainImage.layer.cornerRadius = 0
        self.mainImage.layer.borderWidth = 0
        self.mainImage.layer.borderColor = nil
        mainImage.contentMode = .ScaleAspectFit
    }
    
    @IBAction func sendFripple(sender: AnyObject) {
        //Code to check if the text or image options are blank
        if (self.precannedQuestionContainer.text != "" &&
            self.listOfContacts.count > 0) {
                
                if ((PFUser.currentUser()) != nil) {
                    self.activityIndicator.startAnimating()
                    self.activityLabel.alpha = 1
                    self.activityView.alpha = 1
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    
                    //Upload Fripple to Parse
                    let survey = PFObject(className: "Survey")
                    
                    survey["userId"] = PFUser.currentUser()!.objectId!
                    survey["question"] = precannedQuestionContainer.text
                    
                    if self.preCannedImagePicked == true {
                        let imageData = UIImageJPEGRepresentation(mainImage.image!, 0.2)
                        let imageFile = PFFile(name: "image.jpg", data: imageData!)
                        survey["mainImageFile"] = imageFile
                    }
                    
                    survey["surveyTo"] = listOfContacts
                    survey["surveyToPhoneNumbers"] = listOfPhoneNumbers
                    survey["surveyFrom"] = PFUser.currentUser()!.objectForKey("realName")
                    
                    let surveyTypeImage = UIImage(named: "Results_smile")
                    let imageDataType = UIImagePNGRepresentation(surveyTypeImage!)
                    let surveyImageType = PFFile(name: "surveyType.png", data: imageDataType!)
                    survey["surveyType"] = surveyImageType
                    survey["surveyTypeText"] = "Precanned"
                    
                    survey.saveInBackgroundWithBlock { (success, error) -> Void in
                        
                        if error == nil {
                            self.activityIndicator.stopAnimating()
                            self.activityLabel.alpha = 0
                            self.activityView.alpha = 0
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            let alert = UIAlertController(title: "Fripple sent", message: "Your Fripple has been successfully sent", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addAction(UIAlertAction(title: "Great thanks", style: .Default, handler: { (action) -> Void in
                                let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                                self.presentViewController(welcome, animated: false, completion: nil)
                            }))
                            self.presentViewController(alert, animated: false, completion: nil)
                            
                        }
                        else {
                            self.displayAlert("Could not send Fripple", message: "Please try again")
                        }
                    }
                } else {
                    //Present and alert to let the user know they need to sign in
                    let signInTapAlert = UIAlertController(title: "Sign up to send", message: "At this point, you need to sign up. Signing up gives you the ability to send and recieve Fripples from friends as well as track results of Fripples sent or taken. And, we totally take your privacy seriously and we'll NEVER share your info with anyone. Take a look at our privacy info for more details", preferredStyle: .Alert)
                    let signUp = UIAlertAction(title: "Ok, sign up", style: .Default) { (action) in
                        //Go back to sign up screen
                        let goSignUp = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
                        self.presentViewController(goSignUp, animated: false, completion: nil)
                    }
                    signInTapAlert.addAction(signUp)
                    let privacyInfo = UIAlertAction(title: "View privacy info", style: .Default) { (action) in
                        //Go back to sign up screen
                        let goToPrivacyInfo = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyViewController") as! PrivacyViewController
                        self.presentViewController(goToPrivacyInfo, animated: false, completion: nil)
                    }
                    signInTapAlert.addAction(privacyInfo)
                    
                    self.presentViewController(signInTapAlert, animated: false, completion: nil)
                }
        } else {
            displayAlert("Add question/friends", message: "You need to have a question (you can also add an image) with at least one friend selected before you can send your Fripple")
        }
    }
    
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it thanks", style: .Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
}
