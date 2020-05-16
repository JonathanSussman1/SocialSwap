//
//  SceneDelegate.swift
//  SocialSwap
//
//  Created by Daye Jack, Ashley Nussbaum, Jonathan Sussman on 4/4/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var currentUser = User.init()

    // scene - sets the TabBarController "home screen" as the root View Controller if a user
    // is already signed in, thereby superceding the Login View Controller
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if Auth.auth().currentUser != nil {
                              self.getSignedInUser(completion: { currentUser in
                                if let windowScene = scene as? UIWindowScene {
                                       let window = UIWindow(windowScene: windowScene)
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                  let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController") as! TabBarController
                                    tabBarController.currentUser=currentUser
                                    window.rootViewController  = tabBarController
                                       self.window = window
                                       window.makeKeyAndVisible()
                                   }
                              })
                          }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    // getSignedInUser - if a user is already logged in, this function serves to get the current
    // user's data upon opening the app, and stores it in a User object to be conveniently used by
    // other View Controllers
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
                   let uswapreceives = document.data()?["swapReceives"] as! [String:[String:Any]]
                   self.currentUser = User(uid: uid, firstName: ufirstname, lastName: ulastname, email: uemail, phoneNumber: uphonenumber, twitter: utwitter, instagram: uinstagram, facebook: ufb, snapchat: usnapchat, twoWaySwap: utwowayswap, swapReceives: uswapreceives)
                   completion(self.currentUser)
               } else {
                   print("Error getting user")
                   completion(nil)
               }
           }
       }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

