//
//  ViewController.swift
//  Beat Pad
//
//  Created by John Kim on 11/6/20.
//

import UIKit
import Foundation
import AVFoundation


class ViewController: UIViewController {

    var player: AVAudioPlayer?
    let delay = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
}
    
    @IBAction func nodePressed(_ sender: UIButton) {
        print("Button: \(sender.currentTitle!)")
        GSAudio.sharedInstance.playSound(soundFileName: sender.currentTitle!)
    }
    
    func playSound(beat: UIButton) {
//        guard let url = Bundle.main.url(forResource: beat.currentTitle!, withExtension: "wav")
//        else {return}
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let player = player else {return}
        let file = beat.currentTitle!
        beat.alpha = 0.3
        let player: GSAudio = GSAudio()
        player.playSound(soundFileName: file)
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                beat.alpha = 1
//            }
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
    }

}
}


//This class is based off of:
//https://stackoverflow.com/questions/36865233/get-avaudioplayer-to-play-multiple-sounds-at-a-time
class GSAudio: NSObject, AVAudioPlayerDelegate {

    static let sharedInstance = GSAudio()

    override init() { }

    var players: [URL: AVAudioPlayer] = [:]
    var duplicatePlayers: [AVAudioPlayer] = []

    func playSound(soundFileName: String) {

        guard let bundle = Bundle.main.path(forResource: soundFileName, ofType: "wav") else { return }
        let soundFileNameURL = URL(fileURLWithPath: bundle)

        if let player = players[soundFileNameURL] { //player for sound has been found

            if !player.isPlaying { //player is not in use, so use that one
                player.prepareToPlay()
                player.play()
            } else { // player is in use, create a new, duplicate, player and use that instead

                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                    let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL)

                    duplicatePlayer.delegate = self
                    //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                    duplicatePlayers.append(duplicatePlayer)
                    //add duplicate to array so it doesn't get removed from memory before finishing

                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()
                } catch let error {
                    print(error.localizedDescription)
                }

            }
        } else { //player has not been found, create a new player with the URL if possible
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
