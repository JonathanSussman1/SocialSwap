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
import CryptoSwift


class QrViewController: UIViewController {
    var currentUser: User?
    var dbloaded = false
    var instagram: Bool = false
    var facebook: Bool = false
    var snapchat: Bool = false
    var twitter: Bool = false
    var contacts: Bool = false
    let soundManager = SoundManager()
    var key: [UInt8]?
    var iv: [UInt8]?
    var canExport = false
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    
    // get key and iv for encryption
    // encrypt data and encode qr
    // display encoded qr code
    override func viewDidLoad() {
        super.viewDidLoad()

        EncryptionHelper.getTheKey { (key, iv) in
            self.key = Data(base64Encoded: key)!.bytes
            self.iv = Data(base64Encoded: iv)!.bytes
            let qrString:String = Code.boolToEncoding(user: self.currentUser, instagram: self.instagram, facebook: self.facebook, twitter: self.twitter, snapchat: self.snapchat, contacts: self.contacts, twoWaySwap: self.currentUser!.twoWaySwap!);
            print(qrString);
            let encrypted = EncryptionHelper.encryptString(strVal: qrString, key: self.key!, iv: self.iv!)
            self.qrImageView.image = Code.generateQr(withString: encrypted);
            self.canExport = true
        }
        
    }


    @IBAction func exportTapped(_ sender: Any) {
        if canExport {
            soundManager.stopPop()
            soundManager.playPop()
            Code.shareQr(vc: self, qrImage: self.qrImageView.image!, closure: {()})
        }
    }

    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
