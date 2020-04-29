//
//  FollowViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/18/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class FollowViewController: UIViewController {
    var user = User()
    var dbloaded = false

    //buttons
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var snapchatButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var contactsButton: UIButton!
    
    
    var scannedUser: User?
    var currentUser: User?
    var csvForSwap: String?
    var sessionStarter: SessionStarterDelegate?
    
    //vars for follow back
    var instagramPressed: Bool = false
    var facebookPressed: Bool = false
    var snapchatPressed: Bool = false
    var twitterPressed: Bool = false
    var contactsPressed: Bool = false
    
    var sendFollowBackNotification: Bool = false
    
     func getSignedInUser(completion:@escaping((User?) -> ())) {

         let db = Firestore.firestore()
        _ = db.collection("users").document(String(Auth.auth().currentUser!.uid)).getDocument { (document, error) in
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
                 let uswapreceives = document.data()?["userNamesOfSwapRecieves"] as! [String]
                self.user = User(uid: uid, firstName: ufirstname, lastName: ulastname, email: uemail, phoneNumber: uphonenumber, twitter: utwitter, instagram: uinstagram, facebook: ufb, snapchat: usnapchat, twoWaySwap: utwowayswap, userNamesOfSwapRecieves: uswapreceives)
                completion(self.user)
                self.viewDidLoad()
              } else {
                 print("Error getting user")
                 completion(nil)
             }
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {

        getSignedInUser(completion: { user in
            self.dbloaded=true
              })

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func DoneButtonPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: {
            if(self.sessionStarter != nil){
                self.sessionStarter!.startSession();
            }
        })
    }
    
    @IBAction func instagramPressed(_ sender: Any) {
        SwapHelper.openInstagram(handle: "Google")
        instagramButton.setTitle("Followed", for: UIControl.State.normal)
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        SwapHelper.openFacebook(url: "facebook.com/Google/")
        facebookButton.setTitle("Added", for: UIControl.State.normal)
    }
    
    @IBAction func snapchatPressed(_ sender: Any) {
        SwapHelper.openSnapchat(handle: "Google")
        snapchatButton.setTitle("Added", for: UIControl.State.normal)
    }
    
    @IBAction func twitterPressed(_ sender: Any) {
        SwapHelper.openTwitter(handle: "Google")
        twitterButton.setTitle("Followed", for: UIControl.State.normal)
    }
    
    @IBAction func contactsPressed(_ sender: Any) {
        SwapHelper.saveContact(firstName: "SocialSwap", lastName: "Testing", phoneNumber: "800111222")
        contactsButton.setTitle("Added", for: UIControl.State.normal)
    }
}
