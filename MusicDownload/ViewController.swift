//
//  ViewController.swift
//  MusicDownload
//
//  Created by erumaru on 11/27/19.
//  Copyright © 2019 kbtu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    var timer: Timer!

    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadMusic(url: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3")
    }

    private func downloadMusic(url: String) {
        guard let url = URL(string: url) else { return }
        
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationURL = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
        
        guard !FileManager.default.fileExists(atPath: destinationURL.path) else {
            self.play(url: destinationURL)
            return
        }
        
        URLSession.shared.downloadTask(with: url) { location, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            try? FileManager.default.moveItem(at: location!, to: destinationURL)
            
            self.play(url: destinationURL)
        }.resume()
    }
    
    private func play(url: URL) {
        player = try? AVAudioPlayer(contentsOf: url)
        
        player.prepareToPlay()
        player.volume = 1
        player.play()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
    }
    
    
    @objc private func updateView() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        
        infoLabel.text = "\(formatter.string(from: player.currentTime)!) : \(formatter.string(from: player.duration)!)"
    }
}

