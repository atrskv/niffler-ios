import XCTest

final class RegistrationTests: BaseTestCase {

  let userName = "user_\(UUID().uuidString.prefix(3))"
  let password = "pass_\(UUID().uuidString.prefix(3))"

  func testRegistration() throws {
    loginPage
      .tapCreateNewAccountButton()

      .registerUser(userName: userName, password: password)

      .assertSuccessAlertShown()
  }

  func testRegistrationFormIsPreFilledFromLoginData() throws {
    loginPage
      .fillLoginForm(userName: userName, password: password, goToSignUp: true)

      .assertSignUpFormPrefilled(
        userName: userName, password: password
      )
  }
}
