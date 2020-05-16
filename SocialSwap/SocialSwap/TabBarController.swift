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
 
 // TabBarController - the "home screen" of the app. allows user to switch between generating
 // a QR code, scanning a QR code, following users back, and editing user settings.
 class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var currentUser: User?
    var dbloaded=false
    let soundManager = SoundManager()
    /*
     - (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
     
     if (preventTabChange)
     return NO;
     
     return YES;
     }
     */
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        //trying to leave settings vc
        if selectedIndex == 3 {
            let settingsVC: SettingsViewController = selectedViewController as! SettingsViewController
            
            //check if all mandatory text fields in the settings vc are filled
            if settingsVC.doneEditing() {
                
                //reset buttons in generate vc if generate selected (enable and disable appropriately)
                if viewController == viewControllers?[0] {
                    let generateVC: GenerateViewController = viewController as! GenerateViewController
                    for i in 0..<generateVC.buttons.count {
                        generateVC.buttons[i].isEnabled = true
                    }
                    generateVC.setButtons()
                }
                
                //leave the settings tab if all fields are sufficiently filled
                return true
            }
            //don't leave the settings tab if there are empty mandatory fields
            return false
        }
        
        //user selected notifications tab
        if viewController == viewControllers?[2] {
            
            let notificationsVC: NotificationsTableViewController = viewController as! NotificationsTableViewController
            //update notifications table
            notificationsVC.populateTable()
        }
        
        
        return true
    }
    
    // override viewWillAppear - sends the current User object initialized by login/sign up to all
    // other relevant View Controllers
    override func viewWillAppear(_ animated: Bool) {
            self.dbloaded=true
            let settings = (self.viewControllers![3]) as! SettingsViewController as SettingsViewController
            settings.currentUser = self.currentUser
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
    
    // override prepare - passes the current User object via segue in case an error occurs
    // when it is done in viewWillAppear.
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        soundManager.stopClick()
        soundManager.playClick()
    }
 }
