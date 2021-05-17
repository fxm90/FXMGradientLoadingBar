//
//  ProgressLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by myslab on 2021/01/14.
//

import UIKit

/// Type-alias for the controller to be more similar to the pod name.
public typealias ProgressLoadingBar = ProgressLoadingBarController

open class ProgressLoadingBarController: NotchGradientLoadingBarController {
    /// Progress display through rate - Rate range : 0 ~ 1
    public func setProgress(_ rate: CGFloat) {
        guard rate >= 0, rate <= 1 else { return }
        guard let superView = gradientActivityIndicatorView.superview else { return }
        progress = rate
        widthConstraint?.isActive = false
        widthConstraint = gradientActivityIndicatorView.widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: rate)
        widthConstraint?.isActive = true
    }
}
