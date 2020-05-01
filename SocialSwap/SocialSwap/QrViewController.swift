//
//  QrViewController.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class QrViewController: UIViewController {
    var currentUser: User?
    var dbloaded = false
    var instagram: Bool = false
    var facebook: Bool = false
    var snapchat: Bool = false
    var twitter: Bool = false
    var contacts: Bool = false
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // currently boolToEncoding does not encode real values
        // it is using defaults, until we have user data
        let qrString:String = Code.boolToEncoding(user: currentUser, instagram: instagram, facebook: facebook, twitter: twitter, snapchat: snapchat, contacts: contacts, twoWaySwap: currentUser!.twoWaySwap!);
        print(qrString);
        qrImageView.image = Code.generateQr(withString: qrString);
    }


    @IBAction func exportTapped(_ sender: Any) {
        Code.shareQr(vc: self, qrImage: self.qrImageView.image!, closure: {()})
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
