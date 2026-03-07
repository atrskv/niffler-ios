import XCTest

class TestCase: XCTestCase {

  var app: XCUIApplication!

  override func setUp() {
    super.setUp()
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchArguments = ["RemoveAuthOnStart"]
    app.launch()
  }

  override func tearDown() {
    app = nil
    super.tearDown()
  }
}
