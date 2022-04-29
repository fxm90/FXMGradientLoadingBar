//
//  GradientLoadingBarControllerTestCase.swift
//  ExampleSnapshotTests
//
//  Created by Felix Mau on 14.06.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import GradientLoadingBar

final class GradientLoadingBarControllerTestCase: XCTestCase {

    // MARK: - Config

    private enum Config {
        /// The percentage of pixels that must match.
        static let precision: Float = 0.99
    }

    // MARK: - Test cases

    func test_gradientLoadingBarController() {
        // Given
        let rootViewController = UIViewController()
        let gradientLoadingBarController = GradientLoadingBarController()

        // When
        gradientLoadingBarController.fadeIn(duration: 0)

        let expectation = expectation(description: "Wait for view to appear.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        assertSnapshot(matching: rootViewController,
                       as: .image(drawHierarchyInKeyWindow: true, precision: Config.precision))
    }
}