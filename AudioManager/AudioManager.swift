//
//  AudioManager.swift
//  AudioManager
//
//  Created by leehyeonseo on 11/3/24.
//

import AVFoundation

class AudioManager{
    private var player: AVPlayer? = nil;
    
    
    func loadAudio(audioName: UnsafePointer<CChar>){
        let stringName = String(cString: audioName)
        if let fileUrl = Bundle(for: AudioManager.self).url(forResource: stringName, withExtension: "mp3"){
            let playerItem = AVPlayerItem(url: fileUrl)
            if player == nil {
                player = AVPlayer(playerItem: playerItem)
                player?.play();
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playerDidFinishPlaying),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem
                )
            }else{
                player!.replaceCurrentItem(with: playerItem)
            }
        }
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default);
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print("Failed to set audio session category");
        }
    }
    
    func playAudio(){
        guard let player = player else{
            return
        }
        player.play()
    }
    
    func pauseAudio(){
        guard let player = player else{
            return;
        }
        player.pause()
    }
    
    @objc func playerDidFinishPlaying(){
        player?.seek(to: .zero)
        player?.play()
    }
}


let audioManager = AudioManager();

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

