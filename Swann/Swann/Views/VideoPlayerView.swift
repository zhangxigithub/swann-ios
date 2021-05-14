//
//  VideoPlayerView.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import UIKit
import AVKit
import SnapKit

class VideoPlayerView: UIView {

    var player: AVPlayer!
    let playerViewController = AVPlayerViewController()

    init(frame: CGRect, streamURL: URL) {
        super.init(frame: frame)
        clipsToBounds = true

        self.player = AVPlayer(url: streamURL)
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false

        if let playerView = playerViewController.view {
            self.addSubview(playerView)
            playerView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
        enableZoom()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Play control
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
        resetZoom()
        player.pause()
    }
}
