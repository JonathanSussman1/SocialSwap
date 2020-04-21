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

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let isValid=false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    let username = self.usernameField.text ?? ""

        let userRef = Firestore.firestore().collection("users").document(username)

        userRef.getDocument { (document, error) in
            if let document = document {


                if document.exists{
                    let password = document.get("password") as! String
                    if password==self.passwordField.text{
                        
                        self.performSegue(withIdentifier: "loginSegue", sender: self)

                    }

                   
            }
        }
    }
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

