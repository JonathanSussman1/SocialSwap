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


// ScannerViewControlller - a view controller to allow user to capture QR codes and get get data therein
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SessionStarterDelegate {
    var currentUser: User?
    var dbloaded = false
    var user = User()
    let soundManager = SoundManager()
    var key: [UInt8]?
    var iv: [UInt8]?
    
    @IBOutlet weak var previewView: PreviewView!
    var captureSession: AVCaptureSession?
    
    // override viewWillAppear - when the Scanner VC will appear, get the key and iv for encryption/decryption
    // start a capture session to scan qr codes
    override func viewWillAppear(_ animated: Bool) {
        
        UserService.getUser(uid: String(Auth.auth().currentUser!.uid), completion: { user in
            EncryptionHelper.getTheKey { (key, iv) in
                self.key = Data(base64Encoded: key)!.bytes
                self.iv = Data(base64Encoded: iv)!.bytes
                self.dbloaded=true
                self.startSession()
            }
        })
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
    // startSession - create a new instance of AVCaptureSession
    // configure capture session with the scanCode helper function
    func startSession() {
        captureSession = AVCaptureSession()
        Code.scanCode(preview: previewView, delegate: self, captureSession: captureSession!)
    }
    
    // presentInvalidQRAlert - present an invalide alert
    // when cancel is tapped start new capture session
    func presentInvalidQRAlert(){
        let alert = UIAlertController(title: "Invalid QR Code", message: "The QR code scanned is not a valid SocialSwap QR", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
            self.startSession()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //conform to AVCaptureMetadataOutputObjectsDelegate
    // metadataOutput - when a code is scanned check if the qr code is valid
    // if valid, configure and present the follow view controller
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
                
                //if key and iv are valid decrypt scanned string and use for swap
                if(key != nil && iv != nil){
                    decrypted = EncryptionHelper.decryptString(encryptedString: strVal, key: key!, iv: iv!)
                    if(decrypted == nil){
                        self.presentInvalidQRAlert()
                        return
                    }
                }
                else{
                    self.startSession()
                    return
                }

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let followVc = storyboard.instantiateViewController(identifier: "FollowVC") as! FollowViewController
                followVc.csvForSwap = decrypted
                
                followVc.sessionStarter = self
                UserService.getUser(uid: Csv.csvToData(csv: decrypted!)[0]) { (user) in
                    if(user == nil){
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
}
