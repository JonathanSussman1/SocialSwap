//
//  ContactsHelper.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/20/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import Contacts
import UIKit

// SwapHelper - a class for helper methods used when performing swaps
class SwapHelper {
    
    // saveContact - takes a first name, last name and phone number
    // and saves a new contact to the user's phone contacts
    static func saveContact(firstName: String, lastName: String, phoneNumber: String) -> Void {
        let contact = CNMutableContact();
        contact.givenName = firstName;
        contact.familyName = lastName;
        
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))];
        
        //save the newly created contact
        let store = CNContactStore();
        let saveRequest = CNSaveRequest();
        saveRequest.add(contact, toContainerWithIdentifier: nil);
        
        do {
            try store.execute(saveRequest);
        }
        catch {
            print("Error saving contact");
        }
    }
   
    // openTwitter - takes a twitter handle string as an argument.
    // uses twitter's url scheme to open the twitter app,
    // to the specified page by the handle passed in
    static func openTwitter(handle: String) -> Void {
        let urlString = "twitter://user?screen_name=" + handle;
        print(urlString);
        if let url = URL(string: urlString){
            if UIApplication.shared.canOpenURL(url){
                print("can open");
                UIApplication.shared.open(url, options: [:], completionHandler: nil);
            }
        }
    }
    
    // openInstagram - takes a instagram handle string as an argument.
    // uses instagram's url scheme to open the instagram app,
    // to the specified page by the handle passed in
    static func openInstagram(handle: String) -> Void {
        let urlString = "instagram://user?username=" + handle;
        print(urlString);
        if let url = URL(string: urlString){
            if UIApplication.shared.canOpenURL(url){
                print("can open");
                UIApplication.shared.open(url, options: [:], completionHandler: nil);
            }
        }
    }
    
    // openSnapchat - takes a snapchat handle string as an argument.
    // uses snapchat's url scheme to open the snapchat's app,
    // to the specified page by the handle passed in
    static func openSnapchat(handle: String) -> Void {
        let urlString = "snapchat://add/" + handle;
        print(urlString);
        if let url = URL(string: urlString){
            if UIApplication.shared.canOpenURL(url){
                print("can open");
                UIApplication.shared.open(url, options: [:], completionHandler: nil);
            }
        }
    }
    
    // openFacebook - takes a route string as an argument.
    // uses safari to open facebook at the specified url,
    static func openFacebook(url handle: String) -> Void {
        let urlString = "http://www.facebook.com/" + handle;
        print(urlString);
        if let url = URL(string: urlString){
            if UIApplication.shared.canOpenURL(url){
                print("can open");
                UIApplication.shared.open(url, options: [:], completionHandler: nil);
            }
        }
    }
    
}
