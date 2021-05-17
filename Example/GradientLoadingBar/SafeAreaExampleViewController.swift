//
//  SafeAreaExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 30.08.18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class SafeAreaExampleViewController: UIViewController {
    // MARK: - UI properties

    @IBOutlet private var progressSlider: UISlider!

    // MARK: - Private properties

    private let gradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)

    private let notchGradientLoadingBar = NotchGradientLoadingBar(isRelativeToSafeArea: false)

    private let progressLoadingBar = ProgressLoadingBar(isRelativeToSafeArea: false)

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        gradientLoadingBar.fadeOut()
        notchGradientLoadingBar.fadeOut()
    }

    @IBAction func showBasicBarButtonTouchUpInside(_: Any) {
        gradientLoadingBar.fadeIn()
    }

    @IBAction func hideBasicBarButtonTouchUpInside(_: Any) {
        gradientLoadingBar.fadeOut()
    }

    @IBAction func showNotchBarButtonTouchUpInside(_: Any) {
        notchGradientLoadingBar.fadeIn()
    }

    @IBAction func hideNotchBarButtonTouchUpInside(_: Any) {
        notchGradientLoadingBar.fadeOut()
    }

    /// Progress
    @IBAction func showProgressBar(_: UIButton) {
        progressSlider.isHidden = false
        progressLoadingBar.fadeIn()
        progressLoadingBar.setProgress(CGFloat(progressSlider.value))
    }

    @IBAction func hideProgressBar(_: UIButton) {
        progressSlider.isHidden = true
        progressLoadingBar.fadeOut()
    }

    @IBAction func chnageSlider(_ sender: UISlider) {
        progressLoadingBar.setProgress(CGFloat(sender.value))
    }
}
