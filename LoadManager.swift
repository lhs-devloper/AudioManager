//
//  LoadManager.swift
//  AudioManager
//
//  Created by leehyeonseo on 11/4/24.
//

import Foundation


let audioManager = AudioManager();
let gpsManager = GPSManager();
let localNotification = LocalNotificationManager();

// AudioLogic
@_cdecl("loadAudio")
public func loadAudio(audioName: UnsafePointer<CChar>){
//    NSLog("LoadAudio!!!!");
    audioManager.loadAudio(audioName: audioName)
}

@_cdecl("playAudio")
public func playAudio(){
//    NSLog("Play!!!!");
    audioManager.playAudio()
}

@_cdecl("pauseAudio")
public func pauseAudio(){
//    NSLog("PauseAudio!!!!");
    audioManager.pauseAudio()
}


// GPS Logic
@_cdecl("registGPS")
public func registGPS(registLocation: UnsafePointer<CChar>){
//    NSLog("registGPS!!!!");
    gpsManager.registGPS(unsafeJsonString: registLocation)
}

@_cdecl("deleteGPS")
public func deleteGPS(region: UnsafePointer<CChar>) -> Bool{
//    NSLog("deleteGPS!!!!");
    let returnBool = gpsManager.deleteGPS(unSafeName: region)
//    NSLog(String(returnBool))
    return returnBool
}

@_cdecl("returnGPS")
public func returnGPS() -> UnsafePointer<CChar>?{
//    NSLog("returnGPS!!!!");
    return gpsManager.returnGPS()
}

// LocalPush
@_cdecl("localPush")
public func localPush(title: UnsafePointer<CChar>, body: UnsafePointer<CChar>){
//    NSLog("localPush!!!")
//    localNotification.sendNotification(title: title, body: body, seconds: 2.0)
}
