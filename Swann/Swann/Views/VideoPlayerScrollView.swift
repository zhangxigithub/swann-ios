//
//  VideoPlayerScrollView.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import Foundation
import UIKit
import SnapKit

@objc protocol VideoPlayerScrollViewDelegate {
    func overlayStateChanged()
}

class VideoPlayerScrollView: UIView {

    @IBOutlet weak var delegate: VideoPlayerScrollViewDelegate?

    var scrollView: UIScrollView!

    // scrollCanvas's with is equal to self.view.bounds.width * n
    var scrollCanvas: UIStackView!

    var overlayView: UIView!
    var pageControl: UIPageControl!

    var players = [VideoPlayerView]()

    var streamObject: StreamObject? {
        didSet {
            players = streamObject!.streams.map {
                VideoPlayerView(frame: CGRect.zero, streamURL: $0)
            }
            scrollCanvas.arrangedSubviews.forEach {
                scrollCanvas.removeArrangedSubview($0)
            }
            players.forEach {
                scrollCanvas.addArrangedSubview($0)
            }
            pageControl.numberOfPages = players.count
            bringSubviewToFront(pageControl)

            adjustWidth()
            players.first?.play()
        }
    }

    // Adjust content size with "single width" * "count"
    func adjustWidth() {
        scrollCanvas.snp.updateConstraints { (make) in
            make.width.equalTo(self.bounds.size.width * CGFloat(players.count))
        }
        let offset = self.bounds.size.width * CGFloat(pageControl.currentPage)
        scrollView.contentOffset.x = offset
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapScreen(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)

        scrollView = UIScrollView(frame: bounds)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
          make.edges.equalToSuperview()
        }

        scrollCanvas = UIStackView(frame: bounds)
        scrollCanvas.alignment = .fill
        scrollCanvas.distribution = .fillEqually
        scrollCanvas.spacing = 0
        scrollView.addSubview(scrollCanvas)
        scrollCanvas.snp.makeConstraints { (make) in
          make.edges.equalToSuperview()
          make.height.equalToSuperview()
          make.width.equalTo(0)
        }

        overlayView = UIView(frame: bounds)
        overlayView.isUserInteractionEnabled = false
        addSubview(overlayView)
        overlayView.snp.makeConstraints { (make) in
          make.edges.equalToSuperview()
        }

        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 20))
        pageControl.tintColor = .white
        overlayView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
      }

    @objc func tapScreen(_ sender: Any) {
        overlayView.isHidden = !overlayView.isHidden
        delegate?.overlayStateChanged()
    }
}

// MARK: - play control
extension VideoPlayerScrollView {
    
    var currentPlayer: VideoPlayerView? {
        if scrollView == nil || scrollCanvas == nil {
            return nil
        }
        if scrollView.page > players.count {
            return nil
        }
        return players[scrollView.page]
    }

    var isPlaying: Bool {
        return currentPlayer?.isPlaying ?? false
    }

    func playOrPause() {
        currentPlayer?.playOrPause()
    }
}

// MARK: - UIScrollViewDelegate
extension VideoPlayerScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.page

        players.forEach {
            if $0 != currentPlayer {
                $0.stop()
            }
        }
        currentPlayer?.play()
    }
}

// MARK: - UIScrollView extension
fileprivate extension UIScrollView {
    var page: Int {
        return Int(contentOffset.x / bounds.size.width)
    }
}
