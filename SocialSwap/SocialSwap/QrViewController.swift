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
    var dbloaded = false
    var instagram: Bool = false
    var facebook: Bool = false
    var snapchat: Bool = false
    var twitter: Bool = false
    var contacts: Bool = false
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    
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
        print(user.facebook!)
        print(user.email!)
        // currently boolToEncoding does not encode real values
        // it is using defaults, until we have user data
        let qrString:String = Code.boolToEncoding(user: user, instagram: instagram, facebook: facebook, twitter: twitter, snapchat: snapchat, contacts: contacts, twoWaySwap: user.twoWaySwap!);
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
