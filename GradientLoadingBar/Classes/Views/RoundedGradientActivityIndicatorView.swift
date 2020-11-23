//
//  CircleGradientActivityIndicatorView.swift
//  GradientLoadingBar
//
//  Created by Aleksei Cherepanov on 15.11.2020.
//

import Foundation

@available(iOS 12.0, *)
@IBDesignable
open class RoundedGradientActivityIndicatorView: GradientActivityIndicatorView {
    
    // MARK: - Public properties

    public var borderWidth: CGFloat = 3 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    // MARK: - Private properties

    private var cornerRadius: CGFloat = 0
    private var previousRect: CGRect = .zero

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Public methods

    override open func layoutSubviews() {
        super.layoutSubviews()

        var newRadius = superview?.layer.cornerRadius ?? 0
        newRadius = max(0, newRadius - borderWidth)
        let newRect = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        guard newRect != previousRect, newRadius != cornerRadius else { return }

        previousRect = newRect
        cornerRadius = newRadius
        let rectPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: newRect, cornerRadius: cornerRadius)
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        let fillLayer = CAShapeLayer()
        fillLayer.path = rectPath.cgPath
        fillLayer.fillRule = .evenOdd
        layer.mask = fillLayer
    }

    // MARK: - Private methods

    private func commonInit() {
        gradientLayer?.type = .conic
        // gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.5)
        // gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0)
    }
}
