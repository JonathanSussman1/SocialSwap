//
//  FollowViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/18/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {
    
    var scannedUser: User?
    var currentUser: User?
    var csvForSwap: String?
    var sessionStarter: SessionStarterDelegate?
    

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
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        SwapHelper.openFacebook(url: "facebook.com/Google/")
    }
    
    @IBAction func snapchatPressed(_ sender: Any) {
        SwapHelper.openSnapchat(handle: "Google")
    }
    
    @IBAction func twitterPressed(_ sender: Any) {
        SwapHelper.openTwitter(handle: "Google")
    }
    
    @IBAction func contactsPressed(_ sender: Any) {
        SwapHelper.saveContact(firstName: "SocialSwap", lastName: "Testing", phoneNumber: "800111222")
    }
}
