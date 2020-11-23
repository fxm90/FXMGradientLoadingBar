//
//  AdvancedExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/30/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class AdvancedExampleViewController: UIViewController {
    // MARK: - Config

    private enum Config {
        /// The programatically applied height of the `GradientActivityIndicatorView`.
        static let height: CGFloat = 3.5
    }

    // MARK: - Outlets

    @IBOutlet private var programmaticallyButton: BlueBorderedButton!
    @IBOutlet private var customColorsButton: BlueBorderedButton!
    @IBOutlet private var roundedButton: BlueBorderedButton!
    @IBOutlet private var circleButton: UIButton!

    // MARK: - Private properties

    // swiftlint:disable:next identifier_name
    private let programmaticallyGradientActivityIndicatorView = GradientActivityIndicatorView()

    // swiftlint:disable:next identifier_name
    private let customColorsGradientActivityIndicatorView: GradientActivityIndicatorView = {
        let gradientActivityIndicatorView = GradientActivityIndicatorView()

        // Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        gradientActivityIndicatorView.gradientColors = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1)
        ]

        return gradientActivityIndicatorView
    }()

    private let cirlceGradientActivityIndicatorView = RoundedGradientActivityIndicatorView()
    private let roundedGradientActivityIndicatorView = RoundedGradientActivityIndicatorView()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProgrammaticallyGradientActivityIndicatorView()
        setupCustomColorsGradientActivityIndicatorView()
        setupCircleGradientActivityIndicatorView()
        setupRoundedGradientActivityIndicatorView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        programmaticallyGradientActivityIndicatorView.fadeOut()
        customColorsGradientActivityIndicatorView.fadeOut()
    }

    @IBAction func toggleProgrammaticallyButtonTouchUpInside(_: Any) {
        if programmaticallyGradientActivityIndicatorView.isHidden {
            programmaticallyGradientActivityIndicatorView.fadeIn()
        } else {
            programmaticallyGradientActivityIndicatorView.fadeOut()
        }
    }

    @IBAction func toggleCustomColorsButtonTouchUpInside(_: Any) {
        if customColorsGradientActivityIndicatorView.isHidden {
            customColorsGradientActivityIndicatorView.fadeIn()
        } else {
            customColorsGradientActivityIndicatorView.fadeOut()
        }
    }

    @IBAction func toggleCircleButtonTouchUpInside(_: Any) {
        if cirlceGradientActivityIndicatorView.isHidden {
            cirlceGradientActivityIndicatorView.fadeIn()
        } else {
            cirlceGradientActivityIndicatorView.fadeOut()
        }
    }

    @IBAction func toggleRoundedButtonTouchUpInside(_: Any) {
        if roundedGradientActivityIndicatorView.isHidden {
            roundedGradientActivityIndicatorView.fadeIn()
        } else {
            roundedGradientActivityIndicatorView.fadeOut()
        }
    }

    // MARK: - Private methods

    private func setupProgrammaticallyGradientActivityIndicatorView() {
        programmaticallyGradientActivityIndicatorView.fadeOut(duration: 0)

        programmaticallyGradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        programmaticallyButton.addSubview(programmaticallyGradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            programmaticallyGradientActivityIndicatorView.leadingAnchor.constraint(equalTo: programmaticallyButton.leadingAnchor),
            programmaticallyGradientActivityIndicatorView.trailingAnchor.constraint(equalTo: programmaticallyButton.trailingAnchor),

            programmaticallyGradientActivityIndicatorView.topAnchor.constraint(equalTo: programmaticallyButton.topAnchor),
            programmaticallyGradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: Config.height)
        ])
    }

    private func setupCustomColorsGradientActivityIndicatorView() {
        customColorsGradientActivityIndicatorView.fadeOut(duration: 0)

        customColorsGradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        customColorsButton.addSubview(customColorsGradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            customColorsGradientActivityIndicatorView.leadingAnchor.constraint(equalTo: customColorsButton.leadingAnchor),
            customColorsGradientActivityIndicatorView.trailingAnchor.constraint(equalTo: customColorsButton.trailingAnchor),

            customColorsGradientActivityIndicatorView.bottomAnchor.constraint(equalTo: customColorsButton.bottomAnchor),
            customColorsGradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: Config.height)
        ])
    }

    private func setupCircleGradientActivityIndicatorView() {
        circleButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cirlceGradientActivityIndicatorView.fadeOut(duration: 0)

        cirlceGradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        circleButton.addSubview(cirlceGradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            cirlceGradientActivityIndicatorView.leadingAnchor.constraint(equalTo: circleButton.leadingAnchor),
            cirlceGradientActivityIndicatorView.trailingAnchor.constraint(equalTo: circleButton.trailingAnchor),

            cirlceGradientActivityIndicatorView.topAnchor.constraint(equalTo: circleButton.topAnchor),
            cirlceGradientActivityIndicatorView.bottomAnchor.constraint(equalTo: circleButton.bottomAnchor)
        ])
    }

    private func setupRoundedGradientActivityIndicatorView() {
        roundedButton.layer.cornerRadius = 20
        roundedGradientActivityIndicatorView.fadeOut(duration: 0)

        roundedGradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        roundedButton.addSubview(roundedGradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            roundedGradientActivityIndicatorView.leadingAnchor.constraint(equalTo: roundedButton.leadingAnchor),
            roundedGradientActivityIndicatorView.trailingAnchor.constraint(equalTo: roundedButton.trailingAnchor),

            roundedGradientActivityIndicatorView.topAnchor.constraint(equalTo: roundedButton.topAnchor),
            roundedGradientActivityIndicatorView.bottomAnchor.constraint(equalTo: roundedButton.bottomAnchor)
        ])
    }
}
