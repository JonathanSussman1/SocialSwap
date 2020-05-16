//
//  LoginViewController.swift
//  SocialSwap
//
//  Created by Jonathan on 4/19/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

// LoginViewController - a view controller allowing an existing user to sign in
// with their email and password.
class LoginViewController: UIViewController, UITextFieldDelegate {
    var currentUser = User.init()
    @IBOutlet var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let isValid=false
    
    // override loadView - if a user is opens the app and is already logged in, allow time
    // for the sceneDelegate to grab the current user's data from firebase and instantiate the
    // TabBarController home screen as the root view controller. This function prevents this VC
    //  from being seen when an already signed in user opens the app.
    override func loadView() {
        super.loadView()
        if Auth.auth().currentUser != nil{
             RunLoop.current.run(until: NSDate(timeIntervalSinceNow:1) as Date)
        }

    }
    
    // override viewDidLoad - when the view loads,
    // set text field delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        //set text field delegates
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // loginPressed - dissmiss the keyboard if open,
    // and set and pass the logged in user's credentials and firestore data to all VCs
    // via segue. The checking/handling of credential validity takes place in getCurrentUser
    @IBAction func loginPressed(_ sender: Any) {
    
        //dismiss keyboard if open
        if emailField.isFirstResponder {
            emailField.resignFirstResponder()
        }
        else if  passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }
        
        self.getCurrentUser() { (user) -> () in
            if user != nil {
                self.getSignedInUser(completion: { currentUser in
                    self.currentUser=currentUser!
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                })
                
            }
            else {
                print("Not found")
            }
        }
    }
    
    // textFieldShouldReturn - dismisses the keyboard when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // getCurrentUser - checks is the email and password typed by a user
    // is valid, and if so, signs in the user with Firebase Auth. Otherwise,
    // displays the appropriate error alert.
    func getCurrentUser(completion: @escaping ((User?) -> ())) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion:  { authResult, error in
                if authResult != nil{
                    self.currentUser.email=email
                    completion(self.currentUser)
                    
                }
                else{
                    let alert = UIAlertController(title: "Authentication Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    completion(nil)
                }
            })
        }
    }
    
    // getSignedInUser - called after a user's Auth credentials return valid.
    // this stores all relevant data for a current user in s User object
    // to be passed to all other relevant VCs on segue.
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
    
    
   // override touchesBegan - dismiss keyboard when user taps outside of keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.emailField.isFirstResponder{
            emailField.resignFirstResponder()
        }
        else if self.passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }
    }
    
    //override prepare - passes a valid logged in user's data to the TabBarController
    // "home screen" which, from there, gets passed to all other relevant VCs.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue"{
            let vc = segue.destination as! TabBarController
            vc.currentUser=currentUser
        }
    }
}


