//
//  SettingsViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/20/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
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
            
            
            
            //TODO: update database
            
            
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
    
    
    //log out
    @IBAction func logOutButtonPressed(_ sender: Any) {
        //TODO: log user out
    }
    
    
    
    //two-way swap switch
    @IBAction func twoWaySwapChanged(_ sender: Any) {
        //TODO: update database
    }
    
    
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
