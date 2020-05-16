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

// SignUpViewController - the final View Controller that is used for user sign up.
// instagram, facebook, twitter, and snapchat validity are checked here (all optional)
class SignUp2ViewController: UIViewController, UITextFieldDelegate {
    var currentUser=User()
    
    //fields
    @IBOutlet weak var instagramField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var snapchatField: UITextField!
    @IBOutlet weak var twitterField: UITextField!
    var fields: [UITextField] = []
    
    var email: String?,password: String?, firstName: String?,lastName: String?,number: String?,instagram="",instagramSaveField="",facebook="",facebookSaveField="",snapchat="",snapchatSaveField="",twitter="",twitterSaveField=""
    
    //dismiss keyboard if return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //verifyUrl - performs a check to see if a string is a valid URL.
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    // createCurrentUser - if validity checks are passed, this function creates the currentUser
    // in Firebase Auth and Firestore from all the information provided throughout both sign-up VC's.
    // we also store the current user in a User object, to be used conveniently by all other VC's in
    // the app. if some credential is not valid, an alert is thrown.
    func createCurrentUser(completion: @escaping ((User?) -> ())){
        Auth.auth().createUser(withEmail: email!, password: password!, completion:  { authResult, error in
            if authResult != nil{
                let db = Firestore.firestore()
                db.collection("users").document(String((authResult?.user.uid)!)).setData([
                    "id" : String((authResult?.user.uid)!),
                    "email" : self.email!,
                    "firstName" : self.firstName!,
                    "lastName" : self.lastName!,
                    "phoneNumber" : self.number!,
                    "facebook" : self.facebookSaveField,
                    "twitter" : self.twitterSaveField,
                    "instagram" : self.instagramSaveField,
                    "snapchat" : self.snapchatSaveField,
                    "twoWaySwap" : true,
                    "swapReceives" : [String:[String:Any]]()
                ], merge: true)
                
                self.currentUser = User(uid: (authResult?.user.uid)!, firstName: self.firstName!, lastName: self.lastName!, email: self.email!, phoneNumber: self.number!, twitter: self.twitterSaveField, instagram: self.instagramSaveField,
                                        facebook: self.facebookSaveField,
                                        snapchat: self.snapchatSaveField,
                                        twoWaySwap: true,
                                        swapReceives: [String:[String:Any]]() )
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
    
    //getCurrentUser - signs in the newly-created user in firebase Auth, once the sign up button is
    //pressed and all credentials are valid.
    func getCurrentUser(completion: @escaping ((User?) -> ())) {
        if let email = email, let password = password{
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
    
    // getSignedInUser - this function is called after the newly created user is successfully signed
    //in. it initializes the current User object to be passed to all other VC's so that the user's
    // info can be accessed conveniently. although this object is initialized when the user is created,
    // this function does it again to protect against any database latency.
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
    
    // signUpButtonPressed - checks if each field's text (if not empty) is valid (ie, a valid
    // instagram handle, twitter handle, facebook url, and snapchat handle). If any non-empty field is
    // not valid, an alert is thrown. If all fields are valid, the user is created and sign up is completed.
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if (instagramField.text ?? "").isEmpty && (twitterField.text ?? "").isEmpty && (facebookField.text ?? "").isEmpty && (snapchatField.text ?? "").isEmpty{
            let alert = UIAlertController(title: "Continue?", message: "Are you sure you want to continue with no social media?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
                self.createCurrentUser() { (user) -> () in
                if user != nil {
                    self.getCurrentUser() { (user) -> () in
                        if user != nil {
                            self.getSignedInUser(completion: { currentUser in
                                self.currentUser=currentUser!
                                self.performSegue(withIdentifier: "signUpFinalSegue", sender: nil)
                            })
                        }
                    }
                }
            }
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
        self.createCurrentUser() { (user) -> () in
            if user != nil {
                self.getCurrentUser() { (user) -> () in
                    if user != nil {
                        self.getSignedInUser(completion: { currentUser in
                            self.currentUser=currentUser!
                            self.performSegue(withIdentifier: "signUpFinalSegue", sender: nil)
                        })
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //override viewDidLoad - set up UITextFieldDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        //set text field delegates
        fields = [instagramField, facebookField, snapchatField, twitterField]
    
        for field in fields {
            field.delegate = self
        }
    }
    
    // override prepare - pass current User object to the tab bar view controller before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! TabBarController
        vc.currentUser=self.currentUser
        
        
    }
        
   // override touchesBegan - dismiss keyboard when user taps outside of keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.twitterField.isFirstResponder{
            twitterField.resignFirstResponder()
        }
        else if instagramField.isFirstResponder{
            instagramField.resignFirstResponder()
        }
        else if snapchatField.isFirstResponder{
            snapchatField.resignFirstResponder()
        }
        else if facebookField.isFirstResponder {
            facebookField.resignFirstResponder()
        }
    }
    
}
