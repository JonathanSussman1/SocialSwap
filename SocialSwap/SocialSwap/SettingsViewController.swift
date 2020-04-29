//
//  SettingsViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/20/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UIViewController, UITextFieldDelegate {
    var user = User()
    var dbloaded = false

    //username and info labels
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var snapchatLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    var labels: [UILabel] = []
    
    //username and info text fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var instagramField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var snapchatField: UITextField!
    @IBOutlet weak var twitterField: UITextField!
    var fields: [UITextField] = []
    
    //two-way swap switch
    @IBOutlet weak var twoWaySwap: UISwitch!
    
    //buttons
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    //show/hide username and info labels and text fields
    func showTextFields(edit:Bool) {
        
        //copy text from labels to fields
        if edit {
            for i in 0..<fields.count {
                fields[i].text = labels[i].text
            }
        }
        //copy text from fields to labels
        else {
            for i in 0..<labels.count {
                labels[i].text = fields[i].text
            }
        }
        
        //show/hide labels and fields
        for i in 0..<labels.count {
            labels[i].isHidden = edit
            fields[i].isHidden = !edit
        }
    }
    
    //edit button
    @IBAction func editButtonPressed(_ sender: Any) {
        
        //switch into edit mode
        showTextFields(edit: true)
        editButton.isHidden = true
        doneButton.isHidden = false
    }
    
    
    //check for empty mandatory field
    func emptyField() -> String {
        for i in 0...2 {
            if fields[i].text == "" {
                switch i {
                case 0:
                    return "First Name"
                case 1:
                    return "Last Name"
                case 2:
                    return "Phone Number"
                default:
                    return ""
                }
            }
        }
        return ""
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    //switch out of edit mode
    func doneEditing() -> Bool {
        //dismiss keyboard if open
        for field in fields {
            if field.isFirstResponder {
                field.resignFirstResponder()
            }
        }
        
        //check for empty text fields
        let emptyFieldName: String = emptyField()
        //no empty fields
        if emptyFieldName == "" {
            
            var email="",firstName="",lastName="",number="",instagram="",instagramSaveField="",facebook="",facebookSaveField="",snapchat="",snapchatSaveField="",twitter="",twitterSaveField=""
            
            if (!(instagramField.text ?? "").isEmpty){
                instagramSaveField = instagramField.text!.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)

                instagram = "https://instagram.com/\(String( (instagramSaveField)))"
                if verifyUrl(urlString: instagram)==false{
                         let alert = UIAlertController(title: "Invalid Instagram", message: "The Instagram handle you provided is invalid.", preferredStyle: .alert)

                               alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                     
                        self.present(alert, animated: true)
                    return false
                }
                
            }
            if (!(facebookField.text ?? "").isEmpty){
                facebookSaveField = (facebookField.text! as NSString).lastPathComponent

                facebook = "https://www.facebook.com/\(String( (facebookSaveField)))"
                if verifyUrl(urlString: facebook)==false{
                                         let alert = UIAlertController(title: "Invalid Facebook", message: "The Facebook url you provided is invalid.", preferredStyle: .alert)

                              alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                       self.present(alert, animated: true)
                    return false
                }
                
            }
            
            if (!(snapchatField.text ?? "").isEmpty){
                            snapchatSaveField = snapchatField.text!.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
                snapchat = "https://snapchat.com/add/\( String((snapchatSaveField)))/"
                if verifyUrl(urlString: snapchat)==false{
                                         let alert = UIAlertController(title: "Invalid Snapchat", message: "The Snapchat handle you provided is invalid.", preferredStyle: .alert)

                              alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                       self.present(alert, animated: true)
                     return false
                    
                }
                
            }
            
            if (!(twitterField.text ?? "").isEmpty){
                 twitterSaveField = twitterField.text!.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
                let twitter = "https://twitter.com/\(String( (twitterSaveField)))/"
                if verifyUrl(urlString: twitter)==false{
                                         let alert = UIAlertController(title: "Invalid Twitter", message: "The Twitter handle you provided is invalid.", preferredStyle: .alert)

                              alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                       self.present(alert, animated: true)
                     return false
                    
                }
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(String(Auth.auth().currentUser!.uid)).setData([
                "firstName" : firstNameField.text! ,
                "lastName" : lastNameField.text! ,
                "phoneNumber" : numberField.text! ,
                "facebook" : facebookSaveField ,
                "twitter" : twitterSaveField ,
                "instagram" : instagramSaveField ,
                "snapchat" : snapchatSaveField ,
                       ], merge: true)
            
            user.firstName=firstNameField.text
            user.lastName=lastNameField.text
            user.phoneNumber=numberField.text
            user.facebook=facebookSaveField
            user.twitter=twitterSaveField
            user.instagram=instagramSaveField
            user.snapchat=snapchatSaveField

            
            //switch out of edit mode
            showTextFields(edit: false)
            editButton.isHidden = false
            doneButton.isHidden = true
            
            return true
        }
            
        //empty field
        let alert = UIAlertController(title: "Mandatory Field", message:  emptyFieldName + " cannot be empty", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

        self.present(alert, animated: true)
        
        return false
    }
    
    
    
    //done button
    @IBAction func doneButtonPressed(_ sender: Any) {
        //switch out of edit mode
        doneEditing()
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        //switch out of edit mode
        if editButton.isHidden {
            doneEditing()
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        do
        {
             try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
            return false
        }
        return true
    }
    
    
    //two-way swap switch
    @IBAction func twoWaySwapChanged(_ sender: Any) {
        if twoWaySwap.isOn {
         Firestore.firestore().collection("users").document(String(Auth.auth().currentUser!.uid)).setData([
                   "twoWaySwap" : true
                          ], merge: true)
        }
        else{
            Firestore.firestore().collection("users").document(String(Auth.auth().currentUser!.uid)).setData([
            "twoWaySwap" : false
                   ], merge: true)
        }
    }
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
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
                 let uswapreceives = document.data()?["userNamesOfSwapRecieves"] as! [String]
                self.user = User(uid: uid, firstName: ufirstname, lastName: ulastname, email: uemail, phoneNumber: uphonenumber, twitter: utwitter, instagram: uinstagram, facebook: ufb, snapchat: usnapchat, twoWaySwap: utwowayswap, userNamesOfSwapRecieves: uswapreceives)
                completion(self.user)
                self.viewDidLoad()
              } else {
                 print("Error getting user")
                 completion(nil)
             }
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {

        getSignedInUser(completion: { user in
            self.dbloaded=true
              })

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.text=(user.firstName)
        lastNameField.text=(user.lastName)
        numberField.text=(user.phoneNumber)
        instagramField.text=(user.instagram)
        facebookField.text=(user.facebook)
        snapchatField.text=(user.snapchat)
        twitterField.text=(user.twitter)

             
        
        //set twowayswap switch in correct position corresponding to database
        if user.twoWaySwap==true{
            twoWaySwap.setOn(true, animated: false)
        }
        else{
            twoWaySwap.setOn(false, animated: false)
        }

                                
        
        
        
        
        
        // Do any additional setup after loading the view.
        labels = [firstNameLabel, lastNameLabel, numberLabel, instagramLabel, facebookLabel, snapchatLabel, twitterLabel]
        fields = [firstNameField, lastNameField, numberField, instagramField, facebookField, snapchatField, twitterField]
        
        //text field delegates
        for field in fields {
            field.delegate = self
        }
        
        //TODO: fill text fields with user's info and set two-way swap
        
        
        //not in edit mode
        showTextFields(edit: false)
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
