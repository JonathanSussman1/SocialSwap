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

class SwapHelper {
    
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
    
    static func openFacebook(url handle: String) -> Void {
        let urlString = "http://" + handle;
        print(urlString);
        if let url = URL(string: urlString){
            if UIApplication.shared.canOpenURL(url){
                print("can open");
                UIApplication.shared.open(url, options: [:], completionHandler: nil);
            }
        }
    }
    
}
