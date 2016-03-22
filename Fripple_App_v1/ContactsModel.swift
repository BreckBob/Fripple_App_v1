//
//  ContactsModel.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 1/25/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit
import AddressBook

class ContactsModel: NSObject {

    var addressBook: ABAddressBook!
    var delegate:ContactsModelDelegate?
    static let sharedInstance = ContactsModel()
    
    func createAddressBook() {
        var error: Unmanaged<CFErrorRef>?
        
        addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
    }
    
    func accessAddressBook () {
        switch ABAddressBookGetAuthorizationStatus(){
        case .Authorized:
            print("Already authorized")
            createAddressBook()
            self.beginContactSearch()
            
        case .Denied:
            print("You are denied access to the address book")
            
        case .NotDetermined:
            createAddressBook()
            if let theBook: ABAddressBook = addressBook {
                
                ABAddressBookRequestAccessWithCompletion(theBook, {(granted: Bool, error: CFError!) in
                    
                    if granted {
                        
                        print("Access is granted")
                        self.beginContactSearch()
                    }
                    else {
                        
                        print("Access is not granted")
                    }
                })
            }
        case .Restricted:
            print("Access is restricted")
            
        default:
            print("Unhandled")
        }
    }
    
    func beginContactSearch(){
        let records = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
        var contactsArray = [ContactsClass]()
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
                        
                        contactsArray.append(contact)
                    }
                }
            }
            self.delegate?.didDownloadContacts(contactsArray)
        }
    }
}

protocol ContactsModelDelegate {
    func didDownloadContacts(listOfContacts: [ContactsClass])
    
}
