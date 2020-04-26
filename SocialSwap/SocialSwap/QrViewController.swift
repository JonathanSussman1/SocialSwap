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
    var user = User()

    var instagram: Bool = false
    var facebook: Bool = false
    var snapchat: Bool = false
    var twitter: Bool = false
    var contacts: Bool = false
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
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
        // currently boolToEncoding does not encode real values
        // it is using defaults, until we have user data
        let qrString:String = Code.boolToEncoding(user: nil, instagram: instagram, facebook: facebook, twitter: twitter, snapchat: snapchat, contacts: contacts);
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
