//
//  ViewController.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var videoPlayerScrollView: VideoPlayerScrollView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStreams()
    }

    func fetchStreams() {
        self.loadingIndicator.startAnimating()

        StreamManager.shared.fetchStreams { [weak self] streamObject, error in

            guard let self = self else { return }

            self.loadingIndicator.stopAnimating()

            if let error = error {
                let alert = UIAlertController(title: "Fetch error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.fetchStreams()
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            if streamObject?.streams.count == 0 {
                let alert = UIAlertController(title: "No streams", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.fetchStreams()
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.videoPlayerScrollView.streamObject = streamObject
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      coordinator.animate(alongsideTransition: { _ in
      }) { [weak self] _ in
        self?.videoPlayerScrollView.adjustWidth()
      }
      super.viewWillTransition(to: size, with: coordinator)
    }
}

extension ViewController: VideoPlayerScrollViewDelegate {
    func overlayStateChanged() {
        settingButton.isHidden = videoPlayerScrollView.overlayView.isHidden
    }
}
