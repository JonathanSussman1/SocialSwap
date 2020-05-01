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
    var currentUser: User?
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
                self.currentUser = User(uid: uid, firstName: ufirstname, lastName: ulastname, email: uemail, phoneNumber: uphonenumber, twitter: utwitter, instagram: uinstagram, facebook: ufb, snapchat: usnapchat, twoWaySwap: utwowayswap, userNamesOfSwapRecieves: uswapreceives)
                completion(self.currentUser)
                  } else {
                 print("Error getting user")
                 completion(nil)
             }
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {

            self.dbloaded=true
            let settings = (self.viewControllers![3]) as! SettingsViewController as SettingsViewController
            settings.currentUser = self.currentUser
            let table =  NotificationsTableViewController()
            table.currentUser = self.currentUser
            let generate = (self.viewControllers![0]) as! GenerateViewController as GenerateViewController
            generate.currentUser = self.currentUser
            let scanner = (self.viewControllers![1]) as! ScannerViewController as ScannerViewController
                      scanner.currentUser = self.currentUser

        
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
                        vc.currentUser=currentUser
                    }
        else if segue.identifier == "generateSegue"{
                    let vc = segue.destination as! GenerateViewController
                        vc.currentUser=currentUser
                    }
        else if segue.identifier == "notifSegue"{
                    let vc = segue.destination as! NotificationsTableViewController
                        vc.currentUser=currentUser
                    }
        else if segue.identifier == "settingsSegue"{
                    let vc = segue.destination as! SettingsViewController
                        vc.currentUser=currentUser
                    }
     }

    

}
