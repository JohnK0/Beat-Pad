//
//  ViewController.swift
//  Beat Pad
//
//  Created by John Kim on 11/6/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer?
    let delay = 0.2
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func beatPressed(_ beat: UIButton) {
        playSound(beat)
    }
    
    func playSound(_ beat: UIButton) {
        guard let url = Bundle.main.url(forResource: beat.currentTitle!, withExtension: "m4a")
        else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else {return}
            
            beat.alpha = 0.5
            player.play()
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                beat.alpha = 1
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

