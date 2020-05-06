//
//  SoundManager.swift
//  SocialSwap
//
//  Created by DAYE JACK on 5/2/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    var clickSound: AVAudioPlayer?
    var generateSound: AVAudioPlayer?
    var popSound: AVAudioPlayer?
    var cameraSound: AVAudioPlayer?
    
    init(){
        var path = Bundle.main.path(forResource: "snap.mp3", ofType: nil)!
        var url = URL(fileURLWithPath: path)
        do{
            clickSound = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print("could not load file")
        }
        
        path = Bundle.main.path(forResource: "water.mp3", ofType: nil)!
        url = URL(fileURLWithPath: path)
        
        do{
            generateSound = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print("could not load file")
        }
        
        path = Bundle.main.path(forResource: "click.mp3", ofType: nil)!
        url = URL(fileURLWithPath: path)
        
        do{
            popSound = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print("could not load file")
        }
        
        path = Bundle.main.path(forResource: "camera.mp3", ofType: nil)!
        url = URL(fileURLWithPath: path)
        
        do{
            cameraSound = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print("could not load file")
        }
        
        
    }
    
    func playClick(){
        if(clickSound != nil){
            clickSound?.play()
        }
    }
    
    func stopClick(){
        if(clickSound != nil){
            clickSound?.stop()
        }
    }
    
    func playGenerate(){
        if(generateSound != nil){
            generateSound?.play()
        }
    }
    func stopGenerate(){
        if(generateSound != nil){
            generateSound?.stop()
        }
    }
    
    func playPop(){
        if(popSound != nil){
            popSound?.play()
        }
    }
    
    func stopPop(){
        if(popSound != nil){
            popSound?.stop()
        }
    }
    
    func playCamera(){
        if(cameraSound != nil){
            cameraSound?.play()
        }
    }
        
    func stopCamera(){
        if(cameraSound != nil){
            cameraSound?.stop()
        }
    }
    

}
