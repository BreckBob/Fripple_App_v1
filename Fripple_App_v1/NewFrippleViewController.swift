//
//  NewFrippleViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/9/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse

class NewFrippleViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var questionContainer: UITextView!
    var questionText:String!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var UseTextButton: UIButton!
    @IBOutlet weak var UseImageButton: UIButton!
    @IBOutlet weak var UsePrecannedButton: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var answer1Text: UITextField!
    @IBOutlet weak var answer2Text: UITextField!
    @IBOutlet weak var answer3Text: UITextField!
    @IBOutlet weak var answer4Text: UITextField!
    @IBOutlet weak var answersContainer: UIView!
    @IBOutlet weak var sendButton: UIButton!
    var textContactsString:String!
    @IBOutlet weak var numberOfContacts: UILabel!
    var imagePicked = false
    @IBOutlet weak var closeButton: UIButton!
    
    var listOfContacts = [String]()
    var listOfPhoneNumbers = [String]()
    
    let tapGesture = UITapGestureRecognizer()
    
    var textFields = [UITextField]()
    var keyboardPresent = Bool()
    
    var currentViewController: UIViewController!
    
    var presentedVC = "Text"
    
    var imageFromPrecannedFrippleBool:Bool!
    var imageFromPrecannedFripple:UIImage!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        
    }

    //Getting the count of contacts
    @IBAction func unwindFromContacts (sender: UIStoryboardSegue){
        self.numberOfContacts.text = ("\(listOfContacts.count)")
    }
    
    //Capturing data from the precanned view controller
    @IBAction func unwindToNewSurveyViewController (sender: UIStoryboardSegue){
        self.questionContainer.text = questionText
        self.numberOfContacts.text = textContactsString
        
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        //Capturing the image from the precanned view controller
        if imageFromPrecannedFrippleBool == true {
            self.mainImage.layer.masksToBounds = false
            self.mainImage.layer.cornerRadius = 45
            self.mainImage.clipsToBounds = true
            self.mainImage.layer.borderWidth = 5
            self.mainImage.layer.borderColor = borderColor.CGColor
            self.mainImage.contentMode = .ScaleAspectFill
            
            self.mainImage.image = imageFromPrecannedFripple
            self.imagePicked = true
        }
    }
    
    //Capturing data from the image view controller
    @IBAction func unwindFromImageController (sender: UIStoryboardSegue){
        self.questionContainer.text = questionText
        self.numberOfContacts.text = textContactsString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up fromats for view controller
        textFields = [answer1Text, answer2Text, answer3Text, answer4Text]
        
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
        
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        self.questionContainer.delegate = self
        self.questionContainer.layer.cornerRadius = 5
        self.questionContainer.layer.borderWidth = 2
        self.questionContainer.layer.borderColor = borderColor.CGColor
        
        self.answersContainer.layer.borderWidth = 2
        self.answersContainer.layer.borderColor = borderColor.CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        //Add the tap gesture to the main image
        self.tapGesture.addTarget(self, action: "tappedImportImage")
        self.mainImage.addGestureRecognizer(tapGesture)
        self.mainImage.userInteractionEnabled = true
        
        self.activityView.layer.cornerRadius = 10
        self.activityView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToCommand(sender: AnyObject) {
        
        let command = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        self.presentViewController(command, animated: false, completion: nil)
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func tappedImportImage() {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [NSObject : AnyObject]!) {
        
        self.imagePicked = true
        
        self.mainImage.layer.masksToBounds = false
        self.mainImage.layer.cornerRadius = 45
        mainImage.clipsToBounds = true
        let borderColor = UIColor(colorLiteralRed: 125.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.mainImage.layer.borderWidth = 5
        self.mainImage.layer.borderColor = borderColor.CGColor
        self.mainImage.contentMode = .ScaleAspectFill
        self.mainImage.image = image
    }

    @IBAction func clickedContacts(sender: AnyObject) {
        
        //Code to check if the text or image options are blank
        if (self.questionContainer.text != "" &&
            self.answer1Text.text != "" &&
            self.answer2Text.text != "") {
        
            performSegueWithIdentifier("toContacts", sender: sender)
        
            } else {
                displayAlert("Add question/answers", message: "Make sure you have a question with at least two answer choices before adding friends")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        //Segues to pass data to other view controllers
        if segue.identifier == "toNewImageSegue" {
            let toNewFrippleImageViewController = segue.destinationViewController as! NewFrippleImageViewController
            toNewFrippleImageViewController.questionText = questionContainer.text
            toNewFrippleImageViewController.imageContactsString = numberOfContacts.text
            toNewFrippleImageViewController.imageFromNewImageFripple = mainImage.image
            toNewFrippleImageViewController.imageFromNewImageFrippleBool = imagePicked
        }
        if segue.identifier == "toPrecannedSegue" {
            let toNewFripplePrecannedViewController = segue.destinationViewController as! NewFripplePrecannedViewController
            toNewFripplePrecannedViewController.questionText = questionContainer.text
            toNewFripplePrecannedViewController.precannedContactsString = numberOfContacts.text
            toNewFripplePrecannedViewController.imageFromNewFripple = mainImage.image
            toNewFripplePrecannedViewController.imageFromNewFrippleBool = imagePicked
            }
        if segue.identifier == "toContacts" {
            let toContacts = segue.destinationViewController as! ContactsViewController
            toContacts.presentingView = presentedVC
            }
        }
    
    @IBAction func clear(sender: AnyObject) {
        
        self.questionContainer.text = ""
        self.answer1Text.text = ""
        self.answer2Text.text = ""
        self.answer3Text.text = ""
        self.answer4Text.text = ""
        self.numberOfContacts.text = "0"
        
        self.imagePicked = false
        self.mainImage.image = UIImage(named: "Circle_pic")
        self.mainImage.layer.cornerRadius = 0
        self.mainImage.layer.borderWidth = 0
        self.mainImage.layer.borderColor = nil
        mainImage.contentMode = .ScaleAspectFit
    
    }

    @IBAction func sendFripple(sender: AnyObject) {
        
        //Code to check if the text or image options are blank
        if (self.questionContainer.text != "" &&
            self.answer1Text.text != "" &&
            self.answer2Text.text != "" &&
            self.listOfContacts.count > 0) {
                
                if ((PFUser.currentUser()) != nil) {
                    self.activityIndicator.startAnimating()
                    self.activityLabel.alpha = 1
                    self.activityView.alpha = 1
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    
                    //Upload Fripple to Parse
                    let survey = PFObject(className: "Survey")
                    
                    survey["userId"] = PFUser.currentUser()!.objectId!
                    survey["question"] = questionContainer.text
                    survey["answer1"] = answer1Text.text
                    survey["answer2"] = answer2Text.text
                    survey["answer3"] = answer3Text.text
                    survey["answer4"] = answer4Text.text
                    
                    if self.imagePicked == true {
                        
                        let imageData = UIImagePNGRepresentation(mainImage.image!)
                        let imageFile = PFFile(name: "image.png", data: imageData!)
                        survey["mainImageFile"] = imageFile
                        
                    }
        
                    survey["surveyTo"] = self.listOfContacts
                    survey["surveyToPhoneNumbers"] = self.listOfPhoneNumbers
                    survey["surveyFrom"] = PFUser.currentUser()!.objectForKey("realName")
                    
                    let surveyTypeImage = UIImage(named: "Results_text")
                    let imageDataType = UIImagePNGRepresentation(surveyTypeImage!)
                    let surveyImageType = PFFile(name: "surveyType.png", data: imageDataType!)
                    survey["surveyType"] = surveyImageType
                    survey["surveyTypeText"] = "Text"
                    
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
                                
                                self.notification()
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
            displayAlert("Add question/answers/friends", message: "You need to have a question with at least two answer choices and one friend selected before you can send your Fripple")
        }
    }
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it thanks", style: .Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    func notification() {
        
        let installation = PFInstallation.currentInstallation()
        installation["notificationPhoneNumbers"] = self.listOfPhoneNumbers
        installation.saveInBackground()
        
        let pushQuery = PFInstallation.query()
        pushQuery?.whereKey("notificationPhoneNumbers", equalTo: PFUser.currentUser()!.objectForKey("phoneNumber")!)
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set the Installation query
        push.setMessage("Yo, you've recieved a new Fripple")
        push.sendPushInBackgroundWithBlock {
            success, error in
            
            if success {
                print("The push succeeded.")
            } else {
                print("The push failed.")
            }
        }
        
    }

}
