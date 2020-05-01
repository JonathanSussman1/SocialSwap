//
//  SignUp2ViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/20/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUp2ViewController: UIViewController, UITextFieldDelegate {
    var currentUser=User()

    //fields
    @IBOutlet weak var instagramField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var snapchatField: UITextField!
    @IBOutlet weak var twitterField: UITextField!
    var fields: [UITextField] = []
    var email: String?,firstName: String?,lastName: String?,number: String?,instagram="",instagramSaveField="",facebook="",facebookSaveField="",snapchat="",snapchatSaveField="",twitter="",twitterSaveField=""
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    

    @IBAction func signUpButtonPressed(_ sender: Any) {
        if (instagramField.text ?? "").isEmpty && (twitterField.text ?? "").isEmpty && (facebookField.text ?? "").isEmpty && (snapchatField.text ?? "").isEmpty{
            
            let alert = UIAlertController(title: "Continue?", message: "Are you sure you want to continue with no social media?", preferredStyle: .alert)

                  alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in  self.performSegue(withIdentifier: "signUpFinalSegue", sender: nil)
                  
            }))
                self.present(alert, animated: true)
            
        }
        
        if (!(instagramField.text ?? "").isEmpty){
            instagramSaveField = instagramField.text!.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)

            instagram = "https://instagram.com/\(String( (instagramSaveField)))"
            if verifyUrl(urlString: instagram)==false{
                     let alert = UIAlertController(title: "Invalid Instagram", message: "The Instagram handle you provided is invalid.", preferredStyle: .alert)

                           alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                 
                    self.present(alert, animated: true)
                return
            }
            
        }
        if (!(facebookField.text ?? "").isEmpty){
            facebookSaveField = (facebookField.text! as NSString).lastPathComponent

            facebook = "https://www.facebook.com/\(String( (facebookSaveField)))"
            if verifyUrl(urlString: facebook)==false{
                                     let alert = UIAlertController(title: "Invalid Facebook", message: "The Facebook url you provided is invalid.", preferredStyle: .alert)

                          alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                   self.present(alert, animated: true)
                return
            }
            
        }
        
        if (!(snapchatField.text ?? "").isEmpty){
                        snapchatSaveField = snapchatField.text!.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
            snapchat = "https://snapchat.com/add/\( String((snapchatSaveField)))/"
            if verifyUrl(urlString: snapchat)==false{
                                     let alert = UIAlertController(title: "Invalid Snapchat", message: "The Snapchat handle you provided is invalid.", preferredStyle: .alert)

                          alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                   self.present(alert, animated: true)
                return
            }
            
        }
        
        if (!(twitterField.text ?? "").isEmpty){
             twitterSaveField = twitterField.text!.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
            let twitter = "https://twitter.com/\(String( (twitterSaveField)))/"
            if verifyUrl(urlString: twitter)==false{
                                     let alert = UIAlertController(title: "Invalid Twitter", message: "The Twitter handle you provided is invalid.", preferredStyle: .alert)

                          alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                   self.present(alert, animated: true)
                return
            }
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(String(Auth.auth().currentUser!.uid)).setData([
            "facebook" : facebookSaveField ,
            "twitter" : twitterSaveField ,
            "instagram" : instagramSaveField ,
            "snapchat" : snapchatSaveField ,
                   ], merge: true)
        
        currentUser.firstName=firstName
        currentUser.lastName=lastName
        currentUser.email=email
        currentUser.phoneNumber=number
        currentUser.facebook=facebookSaveField
        currentUser.twitter=twitterSaveField
        currentUser.instagram=instagramSaveField
        currentUser.snapchat=snapchatSaveField
        self.performSegue(withIdentifier: "signUpFinalSegue", sender: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        let alert = UIAlertController(title: "Welcome!", message: "Your account was created. Add your social media profiles to your account", preferredStyle: .alert)

              alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: { (action: UIAlertAction!) in  self.performSegue(withIdentifier: "signUpFinalSegue", sender: nil)
              
        }))
            self.present(alert, animated: true)
         */
            
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
//
            
        //
        // Do any additional setup after loading the view.
        fields = [instagramField, facebookField, snapchatField, twitterField]
        
        //text field delegates
        for field in fields {
            field.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let vc = segue.destination as! TabBarController
                     vc.currentUser=currentUser
             
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
