//
//  VideoPlayerView+Zoom.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import UIKit
import AVKit
import SnapKit

extension VideoPlayerView {

    func enableZoom() {
        // Zoom = Pinch + Move

        // Pinch
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(_:)))
        playerViewController.view.addGestureRecognizer(pinchGestureRecognizer)

        // Move
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.move(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 2
        panGestureRecognizer.maximumNumberOfTouches = 2
        playerViewController.view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func pinch(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        guard let pinchView = pinchGestureRecognizer.view else { return }

        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {

            /*
             Scale:
             Step 1: Move view to pinch center
             Step 2: Scale
             Step 3: Move view back
             https://stackoverflow.com/questions/25859069/using-pinchgesture-how-can-i-zoom-in-to-where-a-users-fingers-actually-pinch
             */
            let scale = pinchGestureRecognizer.scale
            let location = pinchGestureRecognizer.location(in: pinchView)
            let center = CGPoint(x: location.x - pinchView.bounds.midX,
                                 y: location.y - pinchView.bounds.midY)
            let transform = pinchView.transform.translatedBy(x: center.x, y: center.y)
                                               .scaledBy(x: scale, y: scale)
                                               .translatedBy(x: -center.x, y: -center.y)
            pinchView.transform = transform
            pinchGestureRecognizer.scale = 1
          }

        // if scale < 1, reset scale
        if pinchView.frame.size.width < pinchView.bounds.size.width {
            if pinchGestureRecognizer.state == .ended || pinchGestureRecognizer.state == .cancelled {
                resetZoom()
            }
        }
    }

    @objc func move(_ panGestureRecognizer: UIPanGestureRecognizer) {

        guard let panView = panGestureRecognizer.view else { return }

        // The view could be scaled
        let transform = playerViewController.view.transform
        var tx = transform.tx + panGestureRecognizer.translation(in: panView).x * transform.a

        // Cannot move out of screen (Only limit left and right)
        let leftMargin = playerViewController.view.frame.origin.x
        if leftMargin > 0 {
            tx -= leftMargin
        }

        let rightMargin = panView.frame.size.width - (-panView.frame.origin.x + panView.bounds.size.width)
        if rightMargin < 0 {
            tx -= rightMargin
        }

        playerViewController.view.transform = CGAffineTransform(a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: tx, ty: transform.ty)
        panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
    }

    func resetZoom() {
        playerViewController.view.transform = .identity
    }
}
