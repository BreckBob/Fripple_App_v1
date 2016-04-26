//
//  NewFrippleImageViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/16/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class NewFrippleImageViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var imageQuestionContainer: UITextView!
    var questionText:String!
    @IBOutlet weak var answersContainer: UIView!
    var keyboardPresent = Bool()
    var imageContactsString:String!
    @IBOutlet weak var numberOfImageContacts: UILabel!
    var imageFromNewImageFripple:UIImage!
    var imageFromNewImageFrippleBool = false
    @IBOutlet weak var addImage1: UIImageView!
    @IBOutlet weak var addImage2: UIImageView!
    @IBOutlet weak var addImage3: UIImageView!
    @IBOutlet weak var addImage4: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    let tapGesture1 = UITapGestureRecognizer()
    let tapGesture2 = UITapGestureRecognizer()
    let tapGesture3 = UITapGestureRecognizer()
    let tapGesture4 = UITapGestureRecognizer()
    
    var image1added = false
    var image2added = false
    var image3added = false
    var image4added = false
    
    var presentedVC = "Image"
    
    var listOfContacts = [String]()
    var listOfPhoneNumbers = [String]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    var textComposer:MFMessageComposeViewController?
    
    //Getting the count of contacts
    @IBAction func unwindFromContacts (sender: UIStoryboardSegue){
        self.numberOfImageContacts.text = ("\(listOfContacts.count)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bring in question text and image from text view controller if its present
        imageQuestionContainer.text = questionText
        numberOfImageContacts.text = imageContactsString
        
        //Set formats for view controller
        self.imageQuestionContainer.delegate = self
        
        self.imageQuestionContainer.layer.cornerRadius = 5
        self.imageQuestionContainer.layer.borderWidth = 2
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.imageQuestionContainer.layer.borderColor = borderColor.CGColor
        
        //Set up notifications for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFrippleImageViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFrippleImageViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.answersContainer.layer.borderWidth = 2
        self.answersContainer.layer.borderColor = borderColor.CGColor

        //Add tap gestures to image views
        tapGesture1.addTarget(self, action: #selector(NewFrippleImageViewController.tappedImportImage1) )
        addImage1.addGestureRecognizer(tapGesture1)
        addImage1.userInteractionEnabled = true
        
        tapGesture2.addTarget(self, action: #selector(NewFrippleImageViewController.tappedImportImage2))
        addImage2.addGestureRecognizer(tapGesture2)
        addImage2.userInteractionEnabled = true
        
        tapGesture3.addTarget(self, action: #selector(NewFrippleImageViewController.tappedImportImage3))
        addImage3.addGestureRecognizer(tapGesture3)
        addImage3.userInteractionEnabled = true
        
        tapGesture4.addTarget(self, action: #selector(NewFrippleImageViewController.tappedImportImage4))
        addImage4.addGestureRecognizer(tapGesture4)
        addImage4.userInteractionEnabled = true
        
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
        
        //Segues to pass data to other view controllers
        if segue.identifier == "toPrecannedSegue" {
            let toNewFripplePrecannedViewController = segue.destinationViewController as! NewFripplePrecannedViewController
            toNewFripplePrecannedViewController.questionText = imageQuestionContainer.text
            toNewFripplePrecannedViewController.precannedContactsString = numberOfImageContacts.text
            toNewFripplePrecannedViewController.imageFromNewFripple = imageFromNewImageFripple
            toNewFripplePrecannedViewController.imageFromNewFrippleBool = imageFromNewImageFrippleBool
        }
        if segue.identifier == "toContacts" {
            let toContacts = segue.destinationViewController as! ContactsViewController
            toContacts.presentingView = presentedVC
        }
        if segue.identifier == "unwindFromImageController" {
            let toNewFrippleViewController = segue.destinationViewController as! NewFrippleViewController
            toNewFrippleViewController.questionText = imageQuestionContainer.text
            toNewFrippleViewController.textContactsString = numberOfImageContacts.text
        }
    }
    
    @IBAction func clear(sender: AnyObject) {
        self.imageQuestionContainer.text = ""
        self.numberOfImageContacts.text = "0"
        
        imageFormatNormal(addImage1)
        imageFormatNormal(addImage2)
        imageFormatNormal(addImage3)
        imageFormatNormal(addImage4)
    }
    
    //Method to implement the import image tap gesture for answer option 1
    func tappedImportImage1() {
        self.image1added = true
        self.image2added = false
        self.image3added = false
        self.image4added = false
        
        addImage()
    }
    
    //Method to implement the import image tap gesture for answer option 2
    func tappedImportImage2() {
        self.image1added = false
        self.image2added = true
        self.image3added = false
        self.image4added = false
        
        addImage()
    }
    
    //Method to implement the import image tap gesture for answer option 3
    func tappedImportImage3() {
        self.image1added = false
        self.image2added = false
        self.image3added = true
        self.image4added = false
        
        addImage()
    }
    
    //Method to implement the import image tap gesture for answer option 4
    func tappedImportImage4() {
        self.image1added = false
        self.image2added = false
        self.image3added = false
        self.image4added = true
        
        addImage()
    }
    
    //Func to pick an image from image gallery
    func addImage () {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [NSObject : AnyObject]!) {
        
        if image1added == true {
            let selectedImage1 = image
            self.addImage1.image = selectedImage1
            imageFormat(addImage1)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        if image2added == true {
            let selectedImage2 = image
            addImage2.image = selectedImage2
            imageFormat(addImage2)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        if image3added == true {
            let selectedImage3 = image
            addImage3.image = selectedImage3
            imageFormat(addImage3)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        if image4added == true {
            let selectedImage4 = image
            addImage4.image = selectedImage4
            imageFormat(addImage4)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func clickedContacts(sender: AnyObject) {
        
        //Code to check if the text or image options are blank
        if (self.imageQuestionContainer.text != ""
            &&
            self.addImage1.image != UIImage(named: "Add_image_blue") &&
            self.addImage2.image != UIImage(named: "Add_image_blue")
            ) {
                
            performSegueWithIdentifier("toContacts", sender: sender)
                
        } else {
            displayAlert("Add question/images", message: "Make sure you have a question with at least two images to compare before adding friends")
        }
    }
    
    //Upload info to parse
    @IBAction func sendFripple(sender: AnyObject) {
        //Code to check if the text or image options are blank
        if (self.imageQuestionContainer.text != "" &&
            self.addImage1.image != UIImage(named: "Add_image_blue") &&
            self.addImage2.image != UIImage(named: "Add_image_blue") &&
            self.listOfContacts.count > 0) {
                
                if ((PFUser.currentUser()) != nil) {
                    self.activityIndicator.startAnimating()
                    self.activityLabel.alpha = 1
                    self.activityView.alpha = 1
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    
                    //Upload Fripple to Parse
                    let survey = PFObject(className: "Survey")
                    
                    survey["userId"] = PFUser.currentUser()!.objectId!
                    survey["question"] = imageQuestionContainer.text
                    
                    if self.addImage1.image == UIImage(named: "Add_image_blue") {
                        survey["answerImage1"] = NSNull()
                    }
                    else {
                        let imageData1 = UIImagePNGRepresentation(addImage1.image!)
                        let imageFile1 = PFFile(name: "image1.png", data: imageData1!)
                        survey["answerImage1"] = imageFile1
                    }
                    
                    if self.addImage2.image == UIImage(named: "Add_image_blue") {
                        survey["answerImage2"] = NSNull()
                    }
                    else {
                        let imageData2 = UIImagePNGRepresentation(addImage2.image!)
                        let imageFile2 = PFFile(name: "image2.png", data: imageData2!)
                        survey["answerImage2"] = imageFile2
                    }
        
                    if self.addImage3.image == UIImage(named: "Add_image_blue") {
                        survey["answerImage3"] = NSNull()
                    }
                    else {
                        let imageData3 = UIImagePNGRepresentation(addImage3.image!)
                        let imageFile3 = PFFile(name: "image3.png", data: imageData3!)
                        survey["answerImage3"] = imageFile3
                    }
                    
                    if self.addImage4.image == UIImage(named: "Add_image_blue") {
                        survey["answerImage4"] = NSNull()
                    }
                    else {
                        let imageData4 = UIImagePNGRepresentation(addImage4.image!)
                        let imageFile4 = PFFile(name: "image4.png", data: imageData4!)
                        survey["answerImage4"] = imageFile4
                    }
                    
                    survey["surveyTo"] = listOfContacts
                    survey["surveyToPhoneNumbers"] = listOfPhoneNumbers
                    survey["surveyFrom"] = PFUser.currentUser()!.objectForKey("realName")
                    
                    let surveyTypeImage = UIImage(named: "Results_image")
                    let imageDataType = UIImagePNGRepresentation(surveyTypeImage!)
                    let surveyImageType = PFFile(name: "surveyType.png", data: imageDataType!)
                    survey["surveyType"] = surveyImageType
                    survey["surveyTypeText"] = "Image"
                    
                    survey.saveInBackgroundWithBlock { (success, error) -> Void in
                        
                        if error == nil {
                            self.activityIndicator.stopAnimating()
                            self.activityLabel.alpha = 0
                            self.activityView.alpha = 0
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            //Present and alert to let the user know the fripple was saved and ask them to tell their friends
                            let signInTapAlert = UIAlertController(title: "Success!", message: "You're Fripple was successfully uploaded. Text your friend(s) to let them know there's a new one to respond to", preferredStyle: .Alert)
                            let signUp = UIAlertAction(title: "OK", style: .Default) { (action) in
                                //Send friend text message
                                self.sendText()
                                
                            }
                            signInTapAlert.addAction(signUp)
                            let privacyInfo = UIAlertAction(title: "No, that's ok", style: .Default) { (action) in
                                //Go back to command center
                                let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                                self.presentViewController(welcome, animated: false, completion: nil)
                            }
                            signInTapAlert.addAction(privacyInfo)
                            
                            self.presentViewController(signInTapAlert, animated: false, completion: nil)
                            
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
            displayAlert("Add question/answers/friends", message: "You need to have a question with at least two answer images and one friend selected before you can send your Fripple")
        }
        
    }
    
    func imageFormat(pic:UIImageView) {
        pic.layer.borderWidth = 5
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        pic.layer.borderColor = borderColor.CGColor
        pic.contentMode = .ScaleAspectFill
        pic.layer.masksToBounds = false
        pic.layer.cornerRadius = 30
        pic.clipsToBounds = true
    }
    
    func imageFormatNormal(pic:UIImageView){
        pic.image = UIImage(named: "Add_image_blue")
        pic.layer.cornerRadius = 0
        pic.layer.borderWidth = 0
        pic.layer.borderColor = nil
        pic.contentMode = .ScaleToFill
    }
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it thanks", style: .Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    func sendText() {
        
        //Check if device can send text
        if MFMessageComposeViewController.canSendText() {
            //Create new message object
            textComposer = MFMessageComposeViewController()
            
            //Set view controller as message delegate
            textComposer?.messageComposeDelegate = self
            
            //Set up text
            textComposer?.recipients = self.listOfPhoneNumbers
            textComposer?.body = "Yo, I just sent you a new Fripple: \(self.imageQuestionContainer.text).\nGo to the app to submit your response"
            
            //Present the message controller
            self.presentViewController(self.textComposer!, animated: true, completion: nil)
        }
        else {
            //User can't send text
            NSLog("Device can't send text messages")
        }
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue :
            self.dismissViewControllerAnimated(true, completion: nil)
            
            //Go back to command center
            let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
            self.presentViewController(welcome, animated: false, completion: nil)
            
        case MessageComposeResultFailed.rawValue :
            self.dismissViewControllerAnimated(true, completion: nil)
            
        case MessageComposeResultSent.rawValue :
            self.dismissViewControllerAnimated(true, completion: nil)
            
            //Go back to command center
            let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
            self.presentViewController(welcome, animated: false, completion: nil)
            
        default:
            break
        }
    }
}
