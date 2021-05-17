//
//  GradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

/// This view model checks for the availability of the key-window,
/// and adds it as a superview to the gradient-view.
final class GradientLoadingBarViewModel {
    // MARK: - Public properties

    /// Observable for the superview of the gradient-view.
    var superview: Observable<UIView?> {
        superviewSubject
    }

    // MARK: - Private properties

    private let superviewSubject: Variable<UIView?> = Variable(nil)

    // MARK: - Dependencies

    private let sharedApplication: UIApplicationProtocol
    private let notificationCenter: NotificationCenter

    // MARK: - Constructor

    init(sharedApplication: UIApplicationProtocol = UIApplication.shared, notificationCenter: NotificationCenter = .default) {
        self.sharedApplication = sharedApplication
        self.notificationCenter = notificationCenter

        if let keyWindow = sharedApplication.windows.first(where: { $0.isKeyWindow }) {
            superviewSubject.value = keyWindow
        }

        // The key window might be not available yet. This can happen, if the initializer is called from
        // `UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)`.
        // Furthermore the key window can change. Therefore we setup an observer to inform the view model
        // when a `UIWindow` object becomes the key window.
        notificationCenter.addObserver(self,
                                       selector: #selector(didReceiveUIWindowDidBecomeKeyNotification(_:)),
                                       name: UIWindow.didBecomeKeyNotification,
                                       object: nil)

        // Ask the system to start notifying when interface change
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        // If change device orientation
        notificationCenter.addObserver(self,
                                       selector: #selector(didChangeOrientationNotification(_:)),
                                       name: UIDevice.orientationDidChangeNotification,
                                       object: nil)
    }

    deinit {
        /// By providing a custom de-initializer we make sure to remove the gradient-view from its superview.
        superviewSubject.value = nil
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods

    @objc private func didReceiveUIWindowDidBecomeKeyNotification(_: Notification) {
        guard let keyWindow = sharedApplication.windows.first(where: { $0.isKeyWindow }) else { return }

        superviewSubject.value = keyWindow
    }

    @objc private func didChangeOrientationNotification(_: Notification) {
        /// Sometimes didn't get correct window, so get some delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let keyWindow = self.sharedApplication.windows.first(where: { $0.isKeyWindow }) else { return }
            self.superviewSubject.value = keyWindow
        }
    }
}

// MARK: - Helper

/// This allows mocking `UIApplication` in tests.
protocol UIApplicationProtocol: AnyObject {
    var windows: [UIWindow] { get }
}

extension UIApplication: UIApplicationProtocol {}
