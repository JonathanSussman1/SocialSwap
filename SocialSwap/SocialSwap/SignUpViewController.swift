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
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword(password :String?) -> Bool {
        guard password != nil else { return false }
     
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
    
func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        if string == ""{
            return true
        }else if str!.count < 3{
            if str!.count == 1{
                numberField.text = "("
            }
        }else if str!.count == 5{
            numberField.text = numberField.text! + ") "
        }else if str!.count == 10{
            numberField.text = numberField.text! + "-"
        }else if str!.count > 14{
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    if textField == numberField{
        return checkEnglishPhoneNumberFormat(string: string, str: str)
    }else{
        return true
    }
}
    
    func modifyCurrentUser(user:User , completion: @escaping (User?) -> ()) {
               if let email = emailField.text, let password = passwordField.text, let firstName = firstNameField.text, let lastName = lastNameField.text, let number = numberField.text, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !number.isEmpty{
                
                if !validateEmail(email: emailField.text!){
                    let alert = UIAlertController(title: "Invalid Email", message: "The email address given is not valid.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                       completion(nil)
                }
                
                else if !validatePassword(password: passwordField.text!){
                    let alert = UIAlertController(title: "Invalid Password", message: "Your password must be at least 8 characters, with at least one uppercase letter, one lowercase letter, and one digit.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                       completion(nil)
                }
                
                else{
                    completion(user)
                }
         
         }
         else{
             let alert = UIAlertController(title: "Empty Fields", message: "One or more fields are empty", preferredStyle: .alert)

             alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

             self.present(alert, animated: true)
                completion(nil)
         }
                }
    
    
    
    
    
    
    //next button
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.modifyCurrentUser(user: currentUser) { (user) -> () in
            if user != nil {
                         self.performSegue(withIdentifier: "firstSignUpSegue", sender: nil)

            }
            else {
                 
            }
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
