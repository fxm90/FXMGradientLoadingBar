//
//  NotchGradientLoadingBarControllerTestCase.swift
//  ExampleSnapshotTests
//
//  Created by Felix Mau on 14.06.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import SnapshotTesting
import XCTest

@testable import GradientLoadingBar

final class NotchGradientLoadingBarControllerTestCase: XCTestCase {
    // swiftlint:disable:previous type_name

    // MARK: - Config

    private enum Config {
        /// The percentage of pixels that must match.
        static let precision: Float = 0.99
    }

    // MARK: - Test cases

    func test_notchGradientLoadingBarController() {
        // Given
        let rootViewController = UIViewController()
        let notchGradientLoadingBarController = NotchGradientLoadingBarController()

        // When
        notchGradientLoadingBarController.fadeIn(duration: 0)

        // Then
        assertSnapshot(matching: rootViewController,
                       as: .image(drawHierarchyInKeyWindow: true, precision: Config.precision))
    }
}
