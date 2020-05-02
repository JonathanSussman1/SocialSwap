//
//  Code.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Code {
    //generate Qr - a function for generating a Qr code with given string encoded
    //takes a string encoding as an argument
    static func generateQr(withString qrStr: String) -> UIImage? {
        
        //inspired by Medium article
        // https://medium.com/@dominicfholmes/generating-qr-codes-in-swift-4-b5dacc75727c
        let data = qrStr.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setValue(data, forKey: "inputMessage")
        
        guard let qrImage = qrFilter.outputImage else {
            return nil
        }
        
        let transform = CGAffineTransform(scaleX: 12, y: 12)
        let scaledImg = qrImage.transformed(by: transform)
        
        //invert colors
        guard let invertedColFilter = CIFilter(name: "CIColorInvert") else {return nil}
        invertedColFilter.setValue(scaledImg, forKey: "inputImage")
        let invertedImg = invertedColFilter.outputImage
        
        //make blacks transparent
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else {return nil}
        blackTransparentFilter.setValue(invertedImg, forKey: "inputImage")
        let blackTransparentImg = blackTransparentFilter.outputImage
       
        //give qr code with transparent background a black tint
        guard let composFilter = CIFilter(name: "CIMultiplyCompositing"), let colorFilter = CIFilter(name: "CIConstantColorGenerator") else {return nil}
        
        let blackCiColor = CIColor(color: UIColor.black)
        colorFilter.setValue(blackCiColor, forKey: kCIInputColorKey)
        let colorImg = colorFilter.outputImage
        
        composFilter.setValue(colorImg, forKey: kCIInputImageKey)
        composFilter.setValue(blackTransparentImg, forKey: kCIInputBackgroundImageKey)
        
        return UIImage(ciImage: composFilter.outputImage!)
    }
    
        
    // scanCode - a function for scanning qr codes
    // takes a previewView, a AVCaptureMetadataOutputObjectsDelegate, and a captureSession as arguments
    // begins capture session for scanning qr code
    static func scanCode(preview: PreviewView, delegate: AVCaptureMetadataOutputObjectsDelegate, captureSession: AVCaptureSession){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureDeviceInput
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch let error {
            print(error)
            return
        }
        
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        }
        else{
            print("error add video input to capture session")
            return;
        }
        

        let metaDataOutput = AVCaptureMetadataOutput()
        if(captureSession.canAddOutput(metaDataOutput)){
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.qr, .ean8, .ean13]
            
        }
        else{
            print("error add metadata output to capture session")
            return
        }
        
        preview.videoPreviewLayer.session = captureSession
        
        captureSession.startRunning()
    }
   
    //shareQr - a function for exporting qr code images
    //takes in a view controller, an image to share, and a closure
    //compresses the image and presents and activity view controller for exporting
    //calls closure function after the activity view controller is presented
    static func shareQr(vc: UIViewController, qrImage: UIImage, closure: @escaping () -> Void){
        guard let image = qrImage.jpegData(compressionQuality: 0.8) else {
            print("error getting jpeg Data")
            return
        }
        
        let actVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.present(actVC, animated: true) {
            closure()
        }
    }
    
    //boolToEncodeing -Takes boolesans and a user and returns a CSV
    //places an X where the user would  not like to share a handl3
    static func boolToEncoding(user: User?, instagram: Bool, facebook: Bool, twitter: Bool, snapchat: Bool, contacts: Bool, twoWaySwap: Bool) -> String {
        var insta: String;
        var snap: String;
        var phonenum: String;
        var name: String;
        var fb: String;
        var tw: String;
        var uid: String;
        
        if instagram {
            insta = user!.instagram!;
        }
        else{
            insta = "";
        }
        if snapchat {
            snap = user!.snapchat!;
        }
        else{
            snap = "";
        }
        if facebook {
            fb = user!.facebook!;
        }
        else{
            fb = "";
        }
        if twitter {
            tw = user!.twitter!;
        }
        else{
            tw = "";
        }
        if contacts {
            phonenum = user!.phoneNumber!;
        }
        else{
            phonenum="";
        }
        if(twoWaySwap){
            uid = user!.uid!;
        }
        else{
            uid = "";
        }
        
        name = user!.firstName! + user!.lastName!;
        
        return Csv.dataToCsv(uid: uid, name: name, phoneNumber: phonenum, instagram: insta, facebook: fb, snapchat: snap, twitter: tw);
    }
    
    
    // encodingToBool - takes an encoded csv swap string, and returns tuple of booleans
    // the returned tuple is true when the user shares a given piece of contact data
    // and false otherwise
    static func encodingToBool(encodedStr: String) -> (Bool, Bool, Bool, Bool, Bool, Bool) {
        let data = Csv.csvToData(csv: encodedStr);
        var twoSwap = false;
        var instagram = false;
        var twitter = false;
        var facebook =  false;
        var contacts = false;
        var snapchat = false;
        if(data[0] != ""){
            twoSwap = true;
        }
        if(data[2] != ""){
            contacts = true;
        }
        if(data[3] != ""){
            instagram = true;
        }
        if(data[4] != ""){
            facebook = true;
        }
        if(data[5] != ""){
            snapchat = true;
        }
        if(data[6] != ""){
            twitter = true;
        }
        
        //return tuple
        return (twoSwap, contacts, instagram, facebook, snapchat, twitter);
    }
}





