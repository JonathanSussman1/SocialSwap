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
    var currentUser: User?

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
    
    
    //check for empty mandatory field, return the name of the empty field (return "" if none are empty)
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
            
            var instagram="",instagramSaveField="",facebook="",facebookSaveField="",snapchat="",snapchatSaveField="",twitterSaveField=""
            
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
            
            currentUser!.firstName=firstNameField.text
            currentUser!.lastName=lastNameField.text
            currentUser!.phoneNumber=numberField.text
            currentUser!.facebook=facebookSaveField
            currentUser!.twitter=twitterSaveField
            currentUser!.instagram=instagramSaveField
            currentUser!.snapchat=snapchatSaveField

            
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
    
    //log out button
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
    
    //dismiss keyboard if return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set text fields with current user's information
        firstNameField.text=(currentUser!.firstName)
        lastNameField.text=(currentUser!.lastName)
        numberField.text=(currentUser!.phoneNumber)
        instagramField.text=(currentUser!.instagram)
        facebookField.text=(currentUser!.facebook)
        snapchatField.text=(currentUser!.snapchat)
        twitterField.text=(currentUser!.twitter)

             
        
        //set twowayswap switch in correct position corresponding to database
        if currentUser!.twoWaySwap==true{
            twoWaySwap.setOn(true, animated: false)
        }
        else{
            twoWaySwap.setOn(false, animated: false)
        }
        
        
        labels = [firstNameLabel, lastNameLabel, numberLabel, instagramLabel, facebookLabel, snapchatLabel, twitterLabel]
        fields = [firstNameField, lastNameField, numberField, instagramField, facebookField, snapchatField, twitterField]
        
        //set text field delegates
        for field in fields {
            field.delegate = self
        }

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
