//
//  SignUpViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/20/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    var fields: [UITextField] = []
    var email="",firstName="",lastName="",number=""
    var user = User()
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    
    
    //next button
    @IBAction func nextButtonPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text, let firstName = firstNameField.text, let lastName = lastNameField.text, let number = numberField.text, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !number.isEmpty{
        Auth.auth().createUser(withEmail: email, password: password, completion:  { authResult, error in
            if authResult != nil{
       Auth.auth().signIn(withEmail: email, password: password, completion:  { signInResult, error in
        if signInResult != nil{
            
            let db = Firestore.firestore()
            db.collection("users").document(String((signInResult?.user.uid)!)).setData([
                "id" : String((signInResult?.user.uid)!),
                "email" : email,
                "firstName" : firstName,
                "lastName" : lastName,
                "phoneNumber" : number,
                "facebook" : "",
                "twitter" : "",
                "instagram" : "",
                "snapchat" : "",
                "twoWaySwap" : true,
                "userNamesOfSwapRecieves" : []
            ], merge: true)
            
            self.user = User(uid: (signInResult?.user.uid)!, firstName: firstName, lastName: lastName, email: email, phoneNumber: number)
            
        
        } else { return }})
                
                       self.performSegue(withIdentifier: "firstSignUpSegue", sender: nil)
                   }
            else{
                    let alert = UIAlertController(title: "Authentication Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
                
        })
        
        }
        else{
            let alert = UIAlertController(title: "Empty Fields", message: "One or more fields are empty", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
        
        //dismiss keyboard if open
        for field in fields {
            if field.isFirstResponder {
                field.resignFirstResponder()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstSignUpSegue"{
            let vc = segue.destination as! SignUp2ViewController
            vc.firstName = firstName
            vc.lastName=lastName
            vc.number=number
            vc.user=user
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fields = [emailField, passwordField, firstNameField, lastNameField, numberField]
        
        //text field delegates
        for field in fields {
            field.delegate = self
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
