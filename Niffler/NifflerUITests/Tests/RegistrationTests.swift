import XCTest

final class RegistrationTests: BaseTestCase {

  let randomUserName = "user_\(UUID().uuidString.prefix(3))"
  let randomPassword = "pass_\(UUID().uuidString.prefix(3))"

  func testRegistration() throws {
    loginPage
      .tapCreateNewAccountButton()

      .registerUser(userName: randomUserName, password: randomPassword)

      .assertSuccessAlertShown()
  }

  func testRegistrationFormIsPreFilledFromLoginData() throws {
    loginPage
      .fillLoginForm(userName: randomUserName, password: randomPassword, goToSignUp: true)

      .assertSignUpFormPrefilled(userName: randomUserName, password: randomPassword
      )
  }
}
