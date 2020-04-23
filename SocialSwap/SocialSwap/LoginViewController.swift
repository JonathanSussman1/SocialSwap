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
        
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion:  { authResult, error in
                if authResult != nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else{
                    let alert = UIAlertController(title: "Authentication Error", message: error?.localizedDescription, preferredStyle: .alert)
                                       alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
            
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
