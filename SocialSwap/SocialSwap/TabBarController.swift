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
        self.delegate = self
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
        if segue.identifier == "toScan"{ //send user object to scanner
                    let vc = segue.destination as! ScannerViewController
                        vc.user=user
                    }
     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
