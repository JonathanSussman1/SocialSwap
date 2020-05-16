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
import AVFoundation

// SignUpViewController - the first View Controller that is used for user sign up.
// email, password, first name, last name, and phone number are validated here.
class SignUpViewController: UIViewController, UITextFieldDelegate {

    //text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    var fields: [UITextField] = []
    
    var email="",firstName="",lastName="",number=""
    var currentUser = User()
    
    
    // textFieldShouldReturn - dismiss keyboard when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // checkEmail - determines if the email entered by the user is already in the database or not.
    func checkEmail(field: String, completion: @escaping (Bool) -> Void) {
        let userRef = Firestore.firestore().collection("users")
        userRef.whereField("email", isEqualTo: field).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["email"] != nil {
                        completion(true)
                    }
                }
                
            }
        }
    }
    
    // validateEmail - evaluates email field text against a regex to determine
    // if user typed in a valid email. This is necessary as opposed
    // to Firebase Auth's implicit check, because Auth is not invoked until the second sign-up VC.
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // validatePassword - regex to determine if user typed in a valid password. A valid password
    // includes at least 8 characters with at least one digit, at least one uppercase letter, and
    // at least one lowercase letter.
    func validatePassword(password :String?) -> Bool {
        guard password != nil else { return false }
     
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    // checkEnglishPhoneNumberFormat - allows the UITextFieldDelegate to manipulate the
    // text field to format an English phone number as the user types.
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        if string == ""{
            return true
        }
        else if str!.count < 3{
            if str!.count == 1{
                numberField.text = "("
            }
        }
        else if str!.count == 5{
            numberField.text = numberField.text! + ") "
        }
        else if str!.count == 10{
            numberField.text = numberField.text! + "-"
        }
        else if str!.count > 14{
            return false
        }
        return true
    }
    
    // textField - used to determine when characters should be changed in
    // a text field. Primarily used by the phone number text field to format
    // phone numbers while a user types.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == numberField{
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }else{
            return true
        }
    }
    
    // modifyCurrentUser - performs checks on all of the text fields when a user
    // wishes to continue to the next sign up screen. If any field is not valid, an alert is thrown.
    // otherwise, a user object is returned on completion.
    func modifyCurrentUser(user:User , completion: @escaping (User?) -> ()) {
               if let email = emailField.text, let password = passwordField.text, let firstName = firstNameField.text, let lastName = lastNameField.text, let number = numberField.text, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !number.isEmpty{
                checkEmail(field: emailField.text!) { (success) in
                if success {
                     let alert = UIAlertController(title: "Invalid Email", message: "A user with this email already exists.", preferredStyle: .alert)

                                       alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    completion(nil)
                } else {
                    
                    if !self.validateEmail(email: self.emailField.text!){
                    let alert = UIAlertController(title: "Invalid Email", message: "The email address given is not valid.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                       completion(nil)
                    }
                    else if !self.validatePassword(password: self.passwordField.text!){
                        let alert = UIAlertController(title: "Invalid Password", message: "Your password must be at least 8 characters, with at least one uppercase letter, one lowercase letter, and one digit.", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                        self.present(alert, animated: true)
                           completion(nil)
                    }
                    
                    else{
                        completion(user)
                    }
                }
            }
         }
         else{
             let alert = UIAlertController(title: "Empty Fields", message: "One or more fields are empty", preferredStyle: .alert)

             alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

             self.present(alert, animated: true)
                completion(nil)
         }
    }
    
   // override touchesBegan - dismiss keyboard when user taps outside of keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.emailField.isFirstResponder{
            emailField.resignFirstResponder()
        }
        else if firstNameField.isFirstResponder{
            firstNameField.resignFirstResponder()
        }
        else if lastNameField.isFirstResponder{
            lastNameField.resignFirstResponder()
        }
        else if  self.numberField.isFirstResponder {
            numberField.resignFirstResponder()
        }
        else if self.passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }
    }
    
    
    
    // nextButtonPressed - if checks on the texts field have passed, proceed to the next sign up
    // VC
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.modifyCurrentUser(user: currentUser) { (user) -> () in
            if user != nil {
                         self.performSegue(withIdentifier: "firstSignUpSegue", sender: nil)

            }
        }
        
        //dismiss keyboard if open
        for field in fields {
            if field.isFirstResponder {
                field.resignFirstResponder()
            }
        }
    }
    
    // override prepare - pass text field info from this VC to the next sign up VC so that
    // it can be stored when the sign up is finally completed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstSignUpSegue"{
            let vc = segue.destination as! SignUp2ViewController
            let email = self.emailField.text
            let firstName = self.firstNameField.text
            let lastName = self.lastNameField.text
            let number = self.numberField.text
            let password = self.passwordField.text
            vc.firstName=firstName
            vc.email=email
            vc.number=number
            vc.lastName=lastName
            vc.password=password
            vc.currentUser=currentUser
            }
        }
    
    // override viewDidLoad - set up UITextFieldDelegate 
    override func viewDidLoad() {
        super.viewDidLoad()

        fields = [emailField, passwordField, firstNameField, lastNameField, numberField]
        
        //set text field delegates
        for field in fields {
            field.delegate = self
        }
    }
}
