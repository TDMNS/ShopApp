//
//  ShopAppUITests.swift
//  ShopAppUITests
//
//  Created by Колбаса Олег on 01.07.2024.
//

import XCTest

final class ShopAppUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
  }
  
  func testCheckAllUIFields() throws {
    // Проверяем наличие полей на экране
    XCTAssert(app.staticTexts["Apple"].waitForExistence(timeout: 0.5))
    XCTAssert(app.staticTexts["Banana"].waitForExistence(timeout: 0.5))
    XCTAssert(app.staticTexts["Orange"].waitForExistence(timeout: 0.5))
  }
  
  func testExample() throws {
    // UI тесты могут запустить приложение несколько раз когда оно тестируется
    let app = XCUIApplication()
    app.launch()
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // Это измерение показывает как долго происходит запуск вашего приложения
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
