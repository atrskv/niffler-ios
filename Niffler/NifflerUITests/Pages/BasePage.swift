import XCTest

class BasePage {

  init(app: XCUIApplication) {
    self.app = app
  }

  let app: XCUIApplication

  @discardableResult
  func expandMenu() -> Self {
    XCTContext.runActivity(named: "Раскрыть верхнее меню") { _ in
      let menuButton = app.images["ic_menu"]
      XCTAssertTrue(menuButton.waitForExistence(timeout: 5))
      menuButton.tap()
    }
    return self
  }

  @discardableResult
  func openProfile() -> Self {
    XCTContext.runActivity(named: "Открыть профиль") { _ in
      expandMenu()
      let profileButton = app.buttons["Profile"]
      XCTAssertTrue(
        profileButton.waitForExistence(timeout: 5))
      profileButton.tap()
    }
    return self
  }
}
