//
//  ScannerViewController.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit
import AVFoundation

protocol SessionStarterDelegate {
    func startSession()
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SessionStarterDelegate {
    
    @IBOutlet weak var previewView: PreviewView!
    var captureSession: AVCaptureSession?
    
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
    
    //when code is scanned print on console
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
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
            self.present(followVc, animated: true)
        }

    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let followvc: FollowViewController = segue.destination as! FollowViewController
        //UNCOMMENT WHEN USER IS ADDED
        //if currentUser.twoWaySwap {
            followvc.sendFollowBackNotification = true
        //}
        //else {
            //followvc.sendFollowBackNotification = false
        //}
    }
    
}
