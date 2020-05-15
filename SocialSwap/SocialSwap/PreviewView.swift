//
//  PreviewView.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

//Inspired by Apple Documentation
// https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/setting_up_a_capture_session

//PreviewView - a view for seeing what the camera sees (used when scanning qr codes)
class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
