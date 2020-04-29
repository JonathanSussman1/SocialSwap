 //
//  TabBarController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/21/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

 class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var user = User()
    var dbloaded=false

    /*
    - (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

        if (preventTabChange)
            return NO;

        return YES;
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if selectedIndex == 3 {
            let settingsVC: SettingsViewController = selectedViewController as! SettingsViewController
            if settingsVC.doneEditing() {
                return true
            }
            return false
        }
        return true
    }
    
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
        self.delegate = self
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
        if segue.identifier == "scannerSegue"{ //send user object to scanner
                    let vc = segue.destination as! ScannerViewController
                        vc.user=user
                    }
        else if segue.identifier == "generateSegue"{
                    let vc = segue.destination as! GenerateViewController
                        vc.user=user
                    }
        else if segue.identifier == "notifSegue"{
                    let vc = segue.destination as! NotificationsTableViewController
                        vc.user=user
                    }
        else if segue.identifier == "settingsSegue"{
                    let vc = segue.destination as! SettingsViewController
                        vc.user=user
                    }
     }

    

}
