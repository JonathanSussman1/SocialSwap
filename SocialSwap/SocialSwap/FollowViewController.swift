//
//  FollowViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/18/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {
    
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
