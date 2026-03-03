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

    loginPage.fillSignUpForm(
      userName: randomUserName,
      password: randomPassword,
      confirmPasswordValue: randomPassword
    )
    loginPage.tapSignUpButton()

    loginPage.assertSuccessAlertShown()
  }

  func testRegistrationFormIsPreFilledFromLoginData() throws {
    loginPage.fillLoginForm(
      userName: randomUserName,
      password: randomPassword
    )

    loginPage.assertSignUpFormPrefilled(
      userName: randomUserName,
      password: randomPassword
    )
  }
}
