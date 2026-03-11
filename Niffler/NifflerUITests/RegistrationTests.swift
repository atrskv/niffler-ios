import XCTest

final class RegistrationTests: TestCase {

  let randomUserName = "user_\(UUID().uuidString.prefix(3))"
  let randomPassword = "pass_\(UUID().uuidString.prefix(3))"

  var loginPage: LoginPage!

  override func setUp() {
    super.setUp()
    loginPage = LoginPage(app: app)
  }

  func testRegistration() throws {
    loginPage.tapCreateNewAccountButton()

    loginPage.registerUser(
      userName: randomUserName,
      password: randomPassword,
    )

    loginPage.assertSuccessAlertShown()
  }

  func testRegistrationFormIsPreFilledFromLoginData() throws {
    loginPage.fillLoginForm(
      userName: randomUserName,
      password: randomPassword,
      goToSignUp: true
    )

    loginPage.assertSignUpFormPrefilled(
      userName: randomUserName,
      password: randomPassword
    )
  }
}
