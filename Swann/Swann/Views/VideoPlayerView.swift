//
//  VideoPlayerView.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import Foundation
import AVKit

class VideoPlayerView: UIView {

    var player: AVPlayer!
    let playerViewController = AVPlayerViewController()

    init(frame: CGRect, streamURL: URL) {
        super.init(frame: frame)

        self.player = AVPlayer(url: streamURL)
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false

        if let playerView = playerViewController.view {
            self.addSubview(playerView)
            playerView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - play control
    func playOrPause() {
        if isPlaying {
            stop()
        } else {
            play()
        }
    }

    var isPlaying: Bool {
        return player.rate != 0
    }

    func play() {
        player.play()
    }

    func stop() {
        player.pause()
    }
}
