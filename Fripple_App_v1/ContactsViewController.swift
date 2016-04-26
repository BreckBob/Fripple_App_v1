//
//  ContactsViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 1/21/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import AddressBook

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

{
    
    @IBOutlet weak var contactsTableView: UITableView!

    var addressBook: ABAddressBook!
    var contactsArray = [ContactsClass]()
    var dataToDisplay = [ContactsClass]()
    var selectedContacts = [String]()
    var selectedContactsPhoneNumbers = [String]()
    @IBOutlet weak var backButton: UIButton!
    var presentingView:String!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    let sections = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    @IBOutlet weak var accessView: UIView!
    var filteredContactsA = [ContactsClass]()
    var filteredContactsB = [ContactsClass]()
    var filteredContactsC = [ContactsClass]()
    var filteredContactsD = [ContactsClass]()
    var filteredContactsE = [ContactsClass]()
    var filteredContactsF = [ContactsClass]()
    var filteredContactsG = [ContactsClass]()
    var filteredContactsH = [ContactsClass]()
    var filteredContactsI = [ContactsClass]()
    var filteredContactsJ = [ContactsClass]()
    var filteredContactsK = [ContactsClass]()
    var filteredContactsL = [ContactsClass]()
    var filteredContactsM = [ContactsClass]()
    var filteredContactsN = [ContactsClass]()
    var filteredContactsO = [ContactsClass]()
    var filteredContactsP = [ContactsClass]()
    var filteredContactsQ = [ContactsClass]()
    var filteredContactsR = [ContactsClass]()
    var filteredContactsS = [ContactsClass]()
    var filteredContactsT = [ContactsClass]()
    var filteredContactsU = [ContactsClass]()
    var filteredContactsV = [ContactsClass]()
    var filteredContactsW = [ContactsClass]()
    var filteredContactsX = [ContactsClass]()
    var filteredContactsY = [ContactsClass]()
    var filteredContactsZ = [ContactsClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactsTableView.backgroundColor = UIColor(red: 246/255, green: 245/255, blue: 245/255, alpha: 1)
        
        self.contactsTableView.allowsMultipleSelection = true
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
        
        self.accessView.alpha = 0
        self.activityView.layer.cornerRadius = 10
        self.activityIndicator.startAnimating()
        self.activityLabel.alpha = 1
        self.activityView.alpha = 1
        
        //Get the contacts and populate tableview
        self.accessAddressBook()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 26
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        
        return self.sections
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
            
        return index
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return self.sections[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return filteredContactsA.count
        case 1:
            return filteredContactsB.count
        case 2:
            return filteredContactsC.count
        case 3:
            return filteredContactsD.count
        case 4:
            return filteredContactsE.count
        case 5:
            return filteredContactsF.count
        case 6:
            return filteredContactsG.count
        case 7:
            return filteredContactsH.count
        case 8:
            return filteredContactsI.count
        case 9:
            return filteredContactsJ.count
        case 10:
            return filteredContactsK.count
        case 11:
            return filteredContactsL.count
        case 12:
            return filteredContactsM.count
        case 13:
            return filteredContactsN.count
        case 14:
            return filteredContactsO.count
        case 15:
            return filteredContactsP.count
        case 16:
            return filteredContactsQ.count
        case 17:
            return filteredContactsR.count
        case 18:
            return filteredContactsS.count
        case 19:
            return filteredContactsT.count
        case 20:
            return filteredContactsU.count
        case 21:
            return filteredContactsV.count
        case 22:
            return filteredContactsW.count
        case 23:
            return filteredContactsX.count
        case 24:
            return filteredContactsY.count
        case 25:
            return filteredContactsZ.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCellWithIdentifier("cell")! as! ContactsTableViewCell
        
        if indexPath.section == 0 {
            cell.textLabel?.text = filteredContactsA[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsA[indexPath.row].phoneNumber
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = filteredContactsB[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsB[indexPath.row].phoneNumber
        }
        if indexPath.section == 2 {
            cell.textLabel?.text = filteredContactsC[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsC[indexPath.row].phoneNumber
        }
        if indexPath.section == 3 {
            cell.textLabel?.text = filteredContactsD[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsD[indexPath.row].phoneNumber
        }
        if indexPath.section == 4 {
            cell.textLabel?.text = filteredContactsE[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsE[indexPath.row].phoneNumber
        }
        if indexPath.section == 5 {
            cell.textLabel?.text = filteredContactsF[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsF[indexPath.row].phoneNumber
        }
        if indexPath.section == 6 {
            cell.textLabel?.text = filteredContactsG[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsG[indexPath.row].phoneNumber
        }
        if indexPath.section == 7 {
            cell.textLabel?.text = filteredContactsH[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsH[indexPath.row].phoneNumber
        }
        if indexPath.section == 8 {
            cell.textLabel?.text = filteredContactsI[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsI[indexPath.row].phoneNumber
        }
        if indexPath.section == 9 {
            cell.textLabel?.text = filteredContactsJ[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsJ[indexPath.row].phoneNumber
        }
        if indexPath.section == 10 {
            cell.textLabel?.text = filteredContactsK[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsK[indexPath.row].phoneNumber
        }
        if indexPath.section == 11 {
            cell.textLabel?.text = filteredContactsL[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsL[indexPath.row].phoneNumber
        }
        if indexPath.section == 12 {
            cell.textLabel?.text = filteredContactsM[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsM[indexPath.row].phoneNumber
        }
        if indexPath.section == 13 {
            cell.textLabel?.text = filteredContactsN[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsN[indexPath.row].phoneNumber
        }
        if indexPath.section == 14 {
            cell.textLabel?.text = filteredContactsO[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsO[indexPath.row].phoneNumber
        }
        if indexPath.section == 15 {
            cell.textLabel?.text = filteredContactsP[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsP[indexPath.row].phoneNumber
        }
        if indexPath.section == 16 {
            cell.textLabel?.text = filteredContactsQ[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsQ[indexPath.row].phoneNumber
        }
        if indexPath.section == 17 {
            cell.textLabel?.text = filteredContactsR[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsR[indexPath.row].phoneNumber
        }
        if indexPath.section == 18 {
            cell.textLabel?.text = filteredContactsS[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsS[indexPath.row].phoneNumber
        }
        if indexPath.section == 19 {
            cell.textLabel?.text = filteredContactsT[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsT[indexPath.row].phoneNumber
        }
        if indexPath.section == 20 {
            cell.textLabel?.text = filteredContactsU[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsU[indexPath.row].phoneNumber
        }
        if indexPath.section == 21 {
            cell.textLabel?.text = filteredContactsV[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsV[indexPath.row].phoneNumber
        }
        if indexPath.section == 22 {
            cell.textLabel?.text = filteredContactsW[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsW[indexPath.row].phoneNumber
        }
        if indexPath.section == 23 {
            cell.textLabel?.text = filteredContactsX[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsX[indexPath.row].phoneNumber
        }
        if indexPath.section == 24 {
            cell.textLabel?.text = filteredContactsY[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsY[indexPath.row].phoneNumber
        }
        if indexPath.section == 25 {
            cell.textLabel?.text = filteredContactsZ[indexPath.row].name
            cell.detailTextLabel?.text = filteredContactsZ[indexPath.row].phoneNumber
        }
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        let image = UIImage(named: "Quesiton_background")
        imageView.image = image
        cell.backgroundView = imageView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let selectedName = selectedCell.textLabel?.text
        let selectedPhoneNumber = selectedCell.detailTextLabel?.text
        
        //Code to reformat phone number to only numbers and then remove the leading 1 in front of it if there is one
        let orginalMobileNumber = selectedPhoneNumber
        var newFormatedPhoneNumber = orginalMobileNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        
        if newFormatedPhoneNumber.characters.count == 11 {
            
            let char = newFormatedPhoneNumber[newFormatedPhoneNumber.startIndex]
            
            if char == "1" {
                
                _ = newFormatedPhoneNumber.removeAtIndex(newFormatedPhoneNumber.startIndex)
            }
        }
        else {
            //The phone number does not have 11 characters
        }
        
        selectedCell.selectionStyle = .None
        let checkMark = UIImageView(image: UIImage(named: "Yes"))
        selectedCell.accessoryView = checkMark
        
        //Capture contact selected and add to array
        if !selectedContacts.contains((selectedName!)) {
            
            selectedContacts.append(selectedName!)
            selectedContactsPhoneNumbers.append(newFormatedPhoneNumber)
            
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cellToDeSelect.accessoryView = nil
        
        //Capture contact deselected, if contact exists in the array remove it
        let selectedName = cellToDeSelect.textLabel?.text
        _ = cellToDeSelect.detailTextLabel?.text
        
        if let foundIndex = selectedContacts.indexOf((selectedName!)) {
            
            //remove the item at the found index
            selectedContacts.removeAtIndex(foundIndex)
            selectedContactsPhoneNumbers.removeAtIndex(foundIndex)
        }
    }
    
    func accessAddressBook () {
        
        switch ABAddressBookGetAuthorizationStatus(){
        case .Authorized:
            print("Already authorized")
            self.createAddressBook()
            self.beginContactSearch()
            
        case .Denied, .Restricted:
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            
            self.accessView.alpha = 1
            self.accessView.layer.cornerRadius = 10
            self.contactsTableView.alpha = 0
            
        case .NotDetermined:
            self.createAddressBook()
            if let  theBook: ABAddressBook = self.addressBook {
                
                ABAddressBookRequestAccessWithCompletion(theBook, {(granted: Bool, error: CFError!) in
                    
                    if granted {
                        
                        print("Access is granted")
                        self.beginContactSearch()
                    }
                    else {
                        
                        print("Access is not granted")
                        self.alertMessage()
                    }
                })
            }
        }
    }
    
    func createAddressBook() {
        var error: Unmanaged<CFErrorRef>?
        
        self.addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
    }
    
    func beginContactSearch(){
        let records = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
        for record in records {
            let object = ABRecordCopyCompositeName(record)
            let contact = ContactsClass()
            if object == nil {
            } else {
                let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(record, kABPersonPhoneProperty).takeRetainedValue()
                for counter in 0..<ABMultiValueGetCount(phoneNumbers){
                    let mobileLabel = ABMultiValueCopyLabelAtIndex(phoneNumbers, counter).takeRetainedValue() as String
                    
                    if mobileLabel == "_$!<Mobile>!$_" {
                        let mobileNumber = ABMultiValueCopyValueAtIndex(phoneNumbers, counter).takeRetainedValue() as! String
                        contact.phoneNumber = mobileNumber
                        
                        let name = object.takeRetainedValue() as NSString
                        contact.name = name as String
                        
                        self.contactsArray.append(contact)
                    }
                    
                    if let found = self.contactsArray.indexOf({$0.name == contact.name}) {
                        print("Person already included")
                    }
                    else {
                        if mobileLabel == "iPhone" {
                            let mobileNumber = ABMultiValueCopyValueAtIndex(phoneNumbers, counter).takeRetainedValue() as! String
                            
                            
                            contact.phoneNumber = mobileNumber
                            
                            let name = object.takeRetainedValue() as NSString
                            contact.name = name as String
                            
                            self.contactsArray.append(contact)
                        }
                    }
                }
            }
        }
        self.createCategories()
    }
    
    func createCategories() {
        self.contactsArray.sortInPlace({ $1.name > $0.name })
        self.dataToDisplay = self.contactsArray
        
        self.filteredContactsA = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("a")
        })
        self.filteredContactsB = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("b")
        })
        self.filteredContactsC = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("c")
        })
        self.filteredContactsD = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("d")
        })
        self.filteredContactsE = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("e")
        })
        self.filteredContactsF = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("f")
        })
        self.filteredContactsG = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("g")
        })
        self.filteredContactsH = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("h")
        })
        self.filteredContactsI = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("i")
        })
        self.filteredContactsJ = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("j")
        })
        self.filteredContactsK = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("k")
        })
        self.filteredContactsL = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("l")
        })
        self.filteredContactsM = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("m")
        })
        self.filteredContactsN = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("n")
        })
        self.filteredContactsO = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("o")
        })
        self.filteredContactsP = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("p")
        })
        self.filteredContactsQ = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("q")
        })
        self.filteredContactsR = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("r")
        })
        self.filteredContactsS = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("s")
        })
        self.filteredContactsT = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("t")
        })
        self.filteredContactsU = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("u")
        })
        self.filteredContactsV = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("v")
        })
        self.filteredContactsW = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("w")
        })
        self.filteredContactsX = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("x")
        })
        self.filteredContactsY = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("y")
        })
        self.filteredContactsZ = self.dataToDisplay.filter({
            $0.name.lowercaseString.hasPrefix("z")
        })
        
        dispatch_async(dispatch_get_main_queue(), {
            self.hiddenView.alpha = 0
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            
            self.contactsTableView.reloadData()
        })
    }

    //Code to pass selected contacts back to view controllers
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if presentingView == "Text" {
            let destinationViewController = segue.destinationViewController as! NewFrippleViewController
            destinationViewController.listOfContacts = selectedContacts
            destinationViewController.listOfPhoneNumbers = selectedContactsPhoneNumbers
        }
        if presentingView == "Image" {
            let destinationViewController = segue.destinationViewController as! NewFrippleImageViewController
            destinationViewController.listOfContacts = selectedContacts
            destinationViewController.listOfPhoneNumbers = selectedContactsPhoneNumbers
        }
        if presentingView == "Precanned" {
            let destinationViewController = segue.destinationViewController as! NewFripplePrecannedViewController
            destinationViewController.listOfContacts = selectedContacts
            destinationViewController.listOfPhoneNumbers = selectedContactsPhoneNumbers
        }
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func alertMessage() {
        self.hiddenView.alpha = 0
        self.activityIndicator.stopAnimating()
        self.activityLabel.alpha = 0
        self.activityView.alpha = 0
        
        //Present and alert to let the user know they need to sign in
        let signInTapAlert = UIAlertController(title: "Error", message: "To create and send Fripples, you need to give permission to access your contacts. If you don't want to, you can still take and view Fripples friends have sent you", preferredStyle: .Alert)
        let give = UIAlertAction(title: "Ok, give permission in settings", style: .Default) { (action) in
            self.openSettings()
            
        }
        signInTapAlert.addAction(give)
        let noAccess = UIAlertAction(title: "No, still don't want to give permission", style: .Default) { (action) in
            //Go back to sign up screen
            let goToCommand = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
            self.presentViewController(goToCommand, animated: false, completion: nil)
        }
        signInTapAlert.addAction(noAccess)
        
        self.presentViewController(signInTapAlert, animated: false, completion: nil)
    }
    
    @IBAction func giveAccess(sender: AnyObject) {
        
        self.openSettings()
    }
    
    @IBAction func noAccess(sender: AnyObject) {
        
        let goToCommand = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        self.presentViewController(goToCommand, animated: false, completion: nil)
        
    }
    
}
