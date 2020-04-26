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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //initialize user object
        let db = Firestore.firestore()
                                db.collection("users").document(String(Auth.auth().currentUser!.uid)).getDocument { (document, error) in
                                    if let document = document, document.exists {
                                       _ = document.data().map(String.init(describing:)) ?? "nil"
                                       self.user.firstName = (document.data()!["firstName"]! as! String)
                                       self.user.lastName = (document.data()!["lastName"]! as! String)
                                       self.user.uid = (document.data()!["id"]! as! String)
                                     self.user.email = (document.data()!["email"]! as! String)
                                     self.user.instagram = (document.data()!["instagram"]! as! String)
                                     self.user.phoneNumber = (document.data()!["phoneNumber"]! as! String)
                                     self.user.snapchat = (document.data()!["snapchat"]! as! String)
                                     self.user.twitter = (document.data()!["twitter"]! as! String)
                                     self.user.twoWaySwap = (document.data()!["twoWaySwap"]! as! Bool)
                                     self.user.userNamesOfSwapRecieves = (document.data()!["userNamesOfSwapRecieves"]! as! Array)
                                    } else {
                                        print("Document does not exist")
                                    }
                                }
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
