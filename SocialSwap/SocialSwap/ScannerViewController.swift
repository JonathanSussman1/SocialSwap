//
//  ScannerViewController.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//
import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

protocol SessionStarterDelegate {
    func startSession()
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SessionStarterDelegate {
    var currentUser: User?
    var dbloaded = false
    var user = User()
    let soundManager = SoundManager()
    
    @IBOutlet weak var previewView: PreviewView!
    var captureSession: AVCaptureSession?

    func getUser(uid: String, completion:@escaping((User?) -> ())) {

        let db = Firestore.firestore()
        _ = db.collection("users").document(uid).getDocument { (document, error) in
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
                self.user = User(uid: uid, firstName: ufirstname, lastName: ulastname, email: uemail, phoneNumber: uphonenumber, twitter: utwitter, instagram: uinstagram, facebook: ufb, snapchat: usnapchat, twoWaySwap: utwowayswap, swapReceives: uswapreceives)
                completion(self.user)
            } else {
                print("Error getting user")
                completion(nil)
            }
        }
    }


    override func viewWillAppear(_ animated: Bool) {

        getUser(uid: String(Auth.auth().currentUser!.uid), completion: { user in
            self.dbloaded=true
              })

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        captureSession = AVCaptureSession()
        Code.scanCode(preview: previewView, delegate: self, captureSession: captureSession!)
        //save contact demo
        //SwapHelper.saveContact(firstName: "Test", lastName: "Tester", phoneNumber: "123456789");
        
        //open Twitter url scheme demo
        //SwapHelper.openTwitter(handle: "Google");
        
        //open instagram test
        //SwapHelper.openInstagram(handle: "Google");
        
        //open snapchat test
        //SwapHelper.openSnapchat(handle: "justinkan");
        
        //open facebook test
        //SwapHelper.openFacebook(url: "facebook.com/Google/");
    }
    
    func startSession() {
        captureSession = AVCaptureSession()
        Code.scanCode(preview: previewView, delegate: self, captureSession: captureSession!)
    }
    
    //when code is scanned do something
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        soundManager.stopCamera()
        soundManager.playCamera()
        
        captureSession?.stopRunning()
        captureSession = nil
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let strVal = readableObject.stringValue else {return}
            print(strVal)
            
            //strVal is our encoded QR Code CSV (possibly)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let followVc = storyboard.instantiateViewController(identifier: "FollowVC") as! FollowViewController
            followVc.csvForSwap = strVal
            followVc.sessionStarter = self
            getUser(uid: Csv.csvToData(csv: strVal)[0]) { (user) in
                followVc.scannedUser = user
                let (_, contacts, instagram, facebook, snapchat, twitter) = Code.encodingToBool(encodedStr: strVal)
                //followVc.twoWaySwapEnabled = twoWaySwap
                followVc.contactsEnabled = contacts
                followVc.instagramEnabled = instagram
                followVc.facebookEnabled = facebook
                followVc.snapchatEnabled = snapchat
                followVc.twitterEnabled = twitter
                
                followVc.currentUser = self.currentUser
                if self.currentUser?.twoWaySwap ?? true && user?.uid != nil {
                    followVc.sendFollowBackNotification = true
                }
                else {
                    followVc.sendFollowBackNotification = false
                }
                
                self.present(followVc, animated: true)
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
}
