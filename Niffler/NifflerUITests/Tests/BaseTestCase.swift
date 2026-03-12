import XCTest

class BaseTestCase: XCTestCase {

  var app: XCUIApplication!

  override func setUp() {
    super.setUp()

    app = XCUIApplication()

    app.launchArguments = ["RemoveAuthOnStart"]
    app.launch()

  }

  override func tearDown() {
    app = nil

    loginPage = nil
    spendsPage = nil
    profilePage = nil

    super.tearDown()
  }

  lazy var loginPage: LoginPage! = LoginPage(app: app)
  lazy var spendsPage: SpendsPage! = SpendsPage(app: app)
  lazy var profilePage: ProfilePage! = ProfilePage(app: app)
}
