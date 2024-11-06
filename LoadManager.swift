//
//  LoadManager.swift
//  AudioManager
//
//  Created by leehyeonseo on 11/4/24.
//

import Foundation


let audioManager = AudioManager();
let gpsManager = GPSManager();


// AudioLogic
@_cdecl("loadAudio")
public func loadAudio(audioName: UnsafePointer<CChar>){
    NSLog("LoadAudio!!!!");
    audioManager.loadAudio(audioName: audioName)
}

@_cdecl("playAudio")
public func playAudio(){
    NSLog("Play!!!!");
    audioManager.playAudio()
}

@_cdecl("pauseAudio")
public func pauseAudio(){
    NSLog("PauseAudio!!!!");
    audioManager.pauseAudio()
}


// GPS Logic
@_cdecl("registGPS")
public func registGPS(registLocation: UnsafePointer<CChar>){
    NSLog("registGPS!!!!");
    gpsManager.registGPS(unsafeJsonString: registLocation)
}

@_cdecl("checkGPS")
public func checkGPS(){
    NSLog("checkGPS!!!!");
    return gpsManager.checkGPS();
}

@_cdecl("returnGPS")
public func returnGPS(){
    NSLog("returnGPS!!!!");
    return gpsManager.returnGPS();
}
