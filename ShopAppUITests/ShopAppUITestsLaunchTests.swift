//
//  ShopAppUITestsLaunchTests.swift
//  ShopAppUITests
//
//  Created by Колбаса Олег on 01.07.2024.
//

import XCTest

final class ShopAppUITestsLaunchTests: XCTestCase {
  
  override class var runsForEachTargetApplicationUIConfiguration: Bool { true }
  
  override func setUpWithError() throws { continueAfterFailure = false }
  
  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()
    
    // Проверяем, что приложение запустилось
    XCTAssertTrue(app.state == .runningForeground)
    
    // Делаем скриншот экрана
    let screenshot = app.screenshot()
    let attachment = XCTAttachment(screenshot: screenshot)
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
