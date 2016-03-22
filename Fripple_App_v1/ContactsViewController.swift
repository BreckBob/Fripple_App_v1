//
//  ContactsViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 1/21/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContactsModelDelegate

{
    
    @IBOutlet weak var contactsTableView: UITableView!

    var contactsArray = [ContactsClass]()
    var dataToDisplay = [ContactsClass]()
    var selectedContacts = [String]()
    var selectedContactsPhoneNumbers = [String]()
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var presentingView:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.backgroundColor = UIColor(red: 246/255, green: 245/255, blue: 245/255, alpha: 1)
        
        addButton.alpha = 0
        backButton.alpha = 1
        
        contactsTableView.allowsMultipleSelection = true
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        ContactsModel.sharedInstance.delegate = self
        ContactsModel.sharedInstance.accessAddressBook()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didDownloadContacts(listOfContacts: [ContactsClass]) {
        contactsArray = listOfContacts
        contactsArray.sortInPlace({ $1.name > $0.name })
        dataToDisplay = contactsArray
        dispatch_async(dispatch_get_main_queue(), {
            self.contactsTableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCellWithIdentifier("cell")! as! ContactsTableViewCell
        
        cell.textLabel?.text = dataToDisplay[indexPath.row].name
        cell.detailTextLabel?.text = dataToDisplay[indexPath.row].phoneNumber
        
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
        
        //Code to reformat phone number to only numbers
        let orginalMobileNumber = selectedPhoneNumber
        let newFormatedPhoneNumber = orginalMobileNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        
        selectedCell.selectionStyle = .None
        let checkMark = UIImageView(image: UIImage(named: "Yes"))
        selectedCell.accessoryView = checkMark
        
        if !selectedContacts.contains((selectedName!)) {
            
            selectedContacts.append(selectedName!)
            selectedContactsPhoneNumbers.append(newFormatedPhoneNumber)
            
            if selectedContacts.count == 0 {
                addButton.alpha = 0
                backButton.alpha = 1
            }
            else {
                addButton.alpha = 1
                backButton.alpha = 0
            }
            
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
            
            if selectedContacts.count == 0 {
                addButton.alpha = 0
                backButton.alpha = 1
            }
            else {
                addButton.alpha = 1
                backButton.alpha = 0
            }
        }
    }

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
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
