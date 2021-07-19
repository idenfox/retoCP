//
//  UILoader.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import Foundation
import UIKit

class UILoader {
    static let instance = UILoader()
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    public func showOverlay(view: UIView) {
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2-60)
        overlayView.backgroundColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1.00)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    func finishOverlay() {
        DispatchQueue.main.async { // Correct
            self.overlayView.removeFromSuperview()
        }
        
    }
}
