 //
//  TabBarController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/21/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

 class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
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

        // Do any additional setup after loading the view.
        self.delegate = self
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
