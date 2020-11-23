//
//  CircleBorderedButton.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/29/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit

@IBDesignable
final class CircleBorderedButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let maxSide = max(size.width, size.height)
        return CGSize(width: maxSide, height: maxSide)
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        backgroundColor = .clear
        tintColor = UIColor.CustomColors.blue

        layer.borderColor = UIColor.CustomColors.blue.cgColor
        layer.borderWidth = 1.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
