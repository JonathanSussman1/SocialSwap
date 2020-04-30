//
//  GenerateViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/14/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class GenerateViewController: UIViewController {
    var currentUser: User?

    //platform buttons
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var snapchatButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var contactsButton: UIButton!
    
    //platform icons
    @IBOutlet weak var instagramIcon: UIImageView!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var snapchatIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var contactsIcon: UIImageView!
    
    //button arrays
    var buttons: [UIButton] = []
    var icons: [UIImageView] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        
        //initialize button arrays
        buttons = [instagramButton, facebookButton, snapchatButton, twitterButton, contactsButton]
        
        icons = [instagramIcon, facebookIcon, snapchatIcon, twitterIcon, contactsIcon]
        
        //deselect all buttons
        for i in 0..<buttons.count {
            buttons[i].alpha = 0.3
            icons[i].alpha = 0.3
        }
    }
    
    
    @IBAction func platformButtonPressed(_ sender: UIButton) {
        
        //select/deselect button
        let icon = icons[buttons.firstIndex(of: sender)!]
        if sender.alpha == 1 {
            sender.alpha = 0.3
            icon.alpha = 0.3
        }
        else {
            sender.alpha = 1
            icon.alpha = 1
        }
    }
    
    //check if any platforms were selected
    func anySelected() -> Bool {
        for button in buttons {
            if button.alpha == 1 {
                return true
            }
        }
        return false
    }
    
    //generate QR code button pressed
    @IBAction func generateButtonPressed(_ sender: Any) {
        
        //display an alert if no platforms are selected
        if !anySelected() {
            let alert = UIAlertController(title: "No platforms selected", message: "You must select at least one platform", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
        else{
            
            
        }
    }
    
    
    //don't segue if no platforms were selected
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return anySelected()
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //destination view controller
        let qrvc: QrViewController = segue.destination as! QrViewController
            qrvc.currentUser=currentUser!
        //check to see which platforms are selected and send to QR view controller
        if instagramButton.alpha == 1 {
            qrvc.instagram = true
        }
        else {
            qrvc.instagram = false
        }
        if facebookButton.alpha == 1 {
            qrvc.facebook = true
        }
        else {
            qrvc.facebook = false
        }
        if snapchatButton.alpha == 1 {
            qrvc.snapchat = true
        }
        else {
            qrvc.snapchat = false
        }
        if twitterButton.alpha == 1 {
            qrvc.twitter = true
        }
        else {
            qrvc.twitter = false
        }
        if contactsButton.alpha == 1 {
            qrvc.contacts = true
        }
        else {
            qrvc.contacts = false
        }
    }
    

}
