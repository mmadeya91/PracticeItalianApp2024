//
//  AudioManager.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import Foundation
import AVKit



final class AudioManager: UIViewController, ObservableObject, AVAudioPlayerDelegate{
    
    @Published var player: AVAudioPlayer?
    
    @Published var currentAudioStoryPlaying: String = "placeholder"
    
    @Published private(set) var isPlaying: Bool = false {
        didSet {
            print("isPlaying", isPlaying)
        }
    }
    
    @Published private(set) var isLooping: Bool = false
    
    @Published private(set) var isSlowPlayback: Bool = false {
        didSet {
            print("isSlowPlayBack", isSlowPlayback)
        }
    }
    
    func setAudioName(nameIn: String){
        currentAudioStoryPlaying = nameIn
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // After successfully finish song playing will stop audio player and remove from memory
            print("Audio player finished playing")
            self.player?.stop()
            isPlaying = false
            //self.player = nil
            // Write code to play next audio.
        }
    }
    
    func startPlayer(track: String, isPreview: Bool = false) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found: \(track)")
            return
        }
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            
            if isPreview {
                player?.prepareToPlay()
            }else {
               
                player?.play()
                isPlaying = true
       
            }
        }catch{
            print("Fail to initialize player", error)
        }
    }
    
    func playPlause() {
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
        }else {
            player.enableRate = true
            player.play()
            isPlaying = true
        }
    }
    
    func slowSpeed() {
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }

        if !isSlowPlayback {
            player.stop()
            player.enableRate = true
            player.prepareToPlay()
            player.rate = 0.7
            player.play()
            isSlowPlayback = true
        }else {
            player.stop()
            player.enableRate = true
            player.prepareToPlay()
            player.rate = 1.0
            player.play()
            isSlowPlayback = false
        }
    }
    
    func stop() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.stop()
            isPlaying = false
        }
    }
    
    func toggleLoop() {
        guard let player = player else { return }
        
        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
        isLooping = player.numberOfLoops != 0
        print("isLooping", isLooping)
        
    }
    
    func togglePlayback(){
        isSlowPlayback.toggle()
    }

}
