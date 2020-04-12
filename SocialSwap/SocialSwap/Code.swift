//
//  Code.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import UIKit

class Code {
    // Generate a Qr code with given string encoded
    static func generateQr(withString qrStr: String) -> UIImage? {
        
        //inspired my Medium article
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
}
