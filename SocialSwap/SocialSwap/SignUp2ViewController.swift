//
//  SignUp2ViewController.swift
//  SocialSwap
//
//  Created by Ashley Nussbaum on 4/20/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController, UITextFieldDelegate {

    //fields
    @IBOutlet weak var instagramField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var snapchatField: UITextField!
    @IBOutlet weak var twitterField: UITextField!
    var fields: [UITextField] = []
    
    
    
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fields = [instagramField, facebookField, snapchatField, twitterField]
        
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
