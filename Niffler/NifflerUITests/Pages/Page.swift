import XCTest

class Page {

  let app: XCUIApplication

  init(app: XCUIApplication) {
    self.app = app
  }

  func expandMenu() {
    XCTContext.runActivity(named: "Раскрыть верхнее меню") { _ in
      let menuButton = app.images["ic_menu"]
      XCTAssertTrue(menuButton.waitForExistence(timeout: 5))
      menuButton.tap()
    }
  }

  func foldMenu(
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Закрыть верхнее меню") { _ in
      app.images["ic_cross"].tap()
    }
  }

  func openProfile() {
    XCTContext.runActivity(named: "Открыть профиль") { _ in
      expandMenu()
      let profileButton = app.buttons["Profile"]
      XCTAssertTrue(
        profileButton.waitForExistence(timeout: 5))
      profileButton.tap()
    }
  }
}
