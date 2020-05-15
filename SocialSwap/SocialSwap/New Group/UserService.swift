//
//  UserService.swift
//  SocialSwap
//
//  Created by DAYE JACK on 5/2/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

// UserService - a class for user database helper methods
class UserService {
   
    // getUser - gets a user from the database with the specified uid
    // if the user exists pass into completion
    // else pass nil into completion
    static func getUser(uid: String, completion:@escaping((User?) -> ())) {
        
        let db = Firestore.firestore()
        _ = db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let uemail = document.data()?["email"] as! String
                let ufb = document.data()?["facebook"] as! String
                let ufirstname = document.data()?["firstName"] as! String
                let uid = document.data()?["id"] as! String
                let uinstagram = document.data()?["instagram"] as! String
                let ulastname = document.data()?["lastName"] as! String
                let uphonenumber = document.data()?["phoneNumber"] as! String
                let usnapchat = document.data()?["snapchat"] as! String
                let utwitter = document.data()?["twitter"] as! String
                let utwowayswap = document.data()?["twoWaySwap"] as! Bool
                let uswapreceives = document.data()?["swapReceives"] as! [String:[String:Any]]
                let user = User(uid: uid, firstName: ufirstname, lastName: ulastname, email: uemail, phoneNumber: uphonenumber, twitter: utwitter, instagram: uinstagram, facebook: ufb, snapchat: usnapchat, twoWaySwap: utwowayswap, swapReceives: uswapreceives)
                completion(user)
            } else {
                print("Error getting user")
                completion(nil)
            }
        }
    }
}
