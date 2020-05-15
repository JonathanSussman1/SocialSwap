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
import CryptoSwift

protocol SessionStarterDelegate {
    func startSession()
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SessionStarterDelegate {
    var currentUser: User?
    var dbloaded = false
    var user = User()
    let soundManager = SoundManager()
    var key: [UInt8]?
    var iv: [UInt8]?
    
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
            EncryptionHelper.getTheKey { (key, iv) in
                self.key = Data(base64Encoded: key)!.bytes
                self.iv = Data(base64Encoded: iv)!.bytes
                self.dbloaded=true
                self.startSession()
            }
        })
        /*
         captureSession = AVCaptureSession()
         Code.scanCode(preview: previewView, delegate: self, captureSession: captureSession!)
         */
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.captureSession?.stopRunning()
        //self.captureSession = nil
        print("view will disappear")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //conforming to SessionStarter protocol
    func startSession() {
        captureSession = AVCaptureSession()
        Code.scanCode(preview: previewView, delegate: self, captureSession: captureSession!)
    }
    
    func presentInvalidQRAlert(){
        let alert = UIAlertController(title: "Invalid QR Code", message: "The QR code scanned is not a valid SocialSwap QR", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
            self.startSession()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //when code is scanned do something
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if self.viewIfLoaded?.window != nil {
            soundManager.stopCamera()
            soundManager.playCamera()
            
            captureSession?.stopRunning()
            captureSession = nil
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
                guard let strVal = readableObject.stringValue else {return}
                print(strVal)
                var decrypted: String? = ""
                
                //decrypt string and use for swap
                if(key != nil && iv != nil){
                    decrypted = EncryptionHelper.decryptString(encryptedString: strVal, key: key!, iv: iv!)
                    if(decrypted == nil){
                        //present invalid alert and return
                        self.presentInvalidQRAlert()
                        return
                    }
                }

                
                //print(decrypted)
                //strVal is our encoded QR Code CSV (possibly)
                //if view controller is visible
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let followVc = storyboard.instantiateViewController(identifier: "FollowVC") as! FollowViewController
                followVc.csvForSwap = decrypted
                
                followVc.sessionStarter = self
                getUser(uid: Csv.csvToData(csv: decrypted!)[0]) { (user) in
                    if(user == nil){
                       //present invalid alert and return
                        self.presentInvalidQRAlert()
                        return
                    }
                    followVc.scannedUser = user
                    let (_, contacts, instagram, facebook, snapchat, twitter) = Code.encodingToBool(encodedStr: decrypted!)
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
