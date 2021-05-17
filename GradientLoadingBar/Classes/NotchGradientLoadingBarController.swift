//
//  NotchGradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 06.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import UIKit

/// Type-alias for the controller to be more similar to the pod name.
public typealias NotchGradientLoadingBar = NotchGradientLoadingBarController

open class NotchGradientLoadingBarController: GradientLoadingBarController {
    // MARK: - Config

    /// Values are based on
    /// <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>
    private enum Config {
        /// The width of the iPhone notch.
        static let notchWidth: CGFloat = 209

        /// The radius of the small circle on the outside of the notch.
        static let smallCircleRadius: CGFloat = 6

        /// The radius of the large circle on the inside of the notch.
        static let largeCircleRadius: CGFloat = 20
    }

    override open func setupConstraints(superview: UIView) {
        guard #available(iOS 11.0, *) else {
            /// The notch is only available when supporting safe area layout guides, which is starting from iOS 11.
            super.setupConstraints(superview: superview)
            return
        }

        // The `safeAreaInsets.top` always includes the status-bar and therefore will always be greater "0".
        // As a workaround we check the bottom inset.
        let hasNotch = superview.safeAreaInsets.bottom > 0

        // The iPad also has a bottom inset, in order to avoid the home indicator. (https://developer.apple.com/forums/thread/110724)
        // As a workaround we explicitly make sure to have a phone device.
        let isIPhone = UIDevice.current.userInterfaceIdiom == .phone

        guard hasNotch, isIPhone else {
            // No special masking required for non safe area devices.
            super.setupConstraints(superview: superview)
            return
        }

        // Our view will be masked therefore the view height needs to cover the notch-height plus the given user-height.
        let height = 2 * Config.smallCircleRadius + Config.largeCircleRadius + self.height

        let widthConstraint = gradientActivityIndicatorView.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: progress)

        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.topAnchor.constraint(equalTo: superview.topAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: height),

            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            widthConstraint,
        ])

        self.widthConstraint = widthConstraint

        // As we currently only support portrait mode (and no device rotation), we can safely use `bounds.size.width` here.
        let screenWidth = superview.bounds.size.width
        if UIDevice.current.orientation == .portrait {
            // You will need NotchMask when device portrait orientation
            applyNotchMask(for: screenWidth)
        } else {
            // If orientation is not portrait just get line mask
            applyLineMask(for: screenWidth)
        }
    }

    // MARK: - Private methods

    private func applyLineMask(for screenWidth: CGFloat) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)

        bezierPath.addLineTo(x: screenWidth, y: 0)

        // Start by moving down at the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: height)

        // Draw line to the beginning of the screen.
        bezierPath.addLineTo(x: 0, y: height)
        bezierPath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath

        if #available(iOS 13.0, *) {
            shapeLayer.cornerCurve = .continuous
        }

        gradientActivityIndicatorView.layer.mask = shapeLayer
    }

    // swiftlint:disable:next function_body_length
    private func applyNotchMask(for screenWidth: CGFloat) {
        // We always center the notch in the middle of the screen.
        let leftNotchPoint = (screenWidth - Config.notchWidth) / 2 + 0.5
        let rightNotchPoint = (screenWidth + Config.notchWidth) / 2

        let smallCircleDiameter: CGFloat = 2 * Config.smallCircleRadius

        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)

        // Draw line to small-circle left to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint - Config.smallCircleRadius,
                             y: 0)

        // Draw the small circle left to the `leftNotchPoint`.
        // See <https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init#1965853> for the definition of the
        // angles in the default coordinate system.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - Config.smallCircleRadius,
                                              y: Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: true)

        // We're moving the the large-circles a bit up.
        // This prevents having a straight line between the circles.
        // See <https://medium.com/tall-west/no-cutting-corners-on-the-iphone-x-97a9413b94e>
        let verticalOffsetForLargeCircle: CGFloat = 3

        // Draw the large circle right to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCircle),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint - Config.largeCircleRadius,
                             y: smallCircleDiameter + Config.largeCircleRadius - verticalOffsetForLargeCircle)

        // Draw the large circle left to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCircle),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: false)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + Config.smallCircleRadius,
                                              y: Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi + CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: 0)

        // And all the way back..
        // Therefore we always have to offset the given `height` by the user.
        // To visually align the height with the "basic" `GradientLoadingBar`, we have to add one point here.
        let height = self.height + 1

        // Have the small-circle at the bottom-path only one third of the size of the upper-path produced visually better results.
        let bottomPathSmallCircleRadius = Config.smallCircleRadius / 3

        // Moving the bottom-line in the corners of the small circles just a tiny bit away from the center point to the smartphone corners,
        // produced a visually more equal height for the gradient-view.
        let bottomPathHorizontalOffsetForSmallCircle: CGFloat = 0.5

        // Moving the bottom-line just a tiny bit down here produced a visually more equal height for the gradient-view underneath
        // the smartphone-frame in the ears and the notch.
        let bottomPathVerticalOffsetForLargeCircle: CGFloat = 0.5

        // Start by moving down at the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: height)

        // Draw line to small-circle right to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint + bottomPathSmallCircleRadius + height,
                             y: height)

        // Draw the small circle right to the `rightNotchPoint`.
        // We're offsetting the center-point with the given user-height here.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + bottomPathSmallCircleRadius + height + bottomPathHorizontalOffsetForSmallCircle,
                                              y: bottomPathSmallCircleRadius + height),
                          radius: bottomPathSmallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: -CGFloat.pi,
                          clockwise: false)

        // Draw the large circle left to the `rightNotchPoint`.
        // We're using the same center-point as the large-circle above, but with a larger radius here.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCircle + bottomPathVerticalOffsetForLargeCircle),
                          radius: Config.largeCircleRadius + height,
                          startAngle: 0,
                          endAngle: CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to large-circle underneath and right to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint + Config.largeCircleRadius + height,
                             y: smallCircleDiameter + Config.largeCircleRadius - verticalOffsetForLargeCircle + height + bottomPathVerticalOffsetForLargeCircle)

        // Draw the large circle right to the `leftNotchPoint`.
        // We're using the same center-point as the large-circle above, but with a larger radius here.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCircle + bottomPathVerticalOffsetForLargeCircle),
                          radius: Config.largeCircleRadius + height,
                          startAngle: CGFloat.pi / 2,
                          endAngle: CGFloat.pi,
                          clockwise: true)

        // Draw the small circle left to the `leftNotchPoint`.
        // We're offsetting the center-point with the given user-height here.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - bottomPathSmallCircleRadius - height - bottomPathHorizontalOffsetForSmallCircle,
                                              y: bottomPathSmallCircleRadius + height),
                          radius: bottomPathSmallCircleRadius,
                          startAngle: 0,
                          endAngle: -CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to the beginning of the screen.
        bezierPath.addLineTo(x: 0, y: height)
        bezierPath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath

        if #available(iOS 13.0, *) {
            shapeLayer.cornerCurve = .continuous
        }

        gradientActivityIndicatorView.layer.mask = shapeLayer
    }
}

// MARK: - Helpers

private extension UIBezierPath {
    // swiftlint:disable:next identifier_name
    func addLineTo(x: CGFloat, y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }
}
