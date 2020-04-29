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

class LoginViewController: UIViewController, UITextFieldDelegate {
    var user = User()
    @IBOutlet var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let isValid=false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //text field delegates
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        
        //dismiss keyboard if open
        if emailField.isFirstResponder {
            emailField.resignFirstResponder()
        }
        else if  passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }
        self.getCurrentUser(user: user) { (user) -> () in
            if user != nil {
                         self.performSegue(withIdentifier: "loginSegue", sender: nil)

            }
            else {
                 print("Not found")
            }
        }

    }
        
    
        //dismiss keyboard
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    func getCurrentUser(user:User , completion: @escaping (User?) -> ()) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion:  { authResult, error in
                 if authResult != nil{
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
                                completion(self.user)
                             }
                             else {
                                             print("Document does not exist")
                                completion(nil)
                                         }
                                     }
                                
                                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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


                
                
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    

}

