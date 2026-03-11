import XCTest

class LoginPage: Page {

  func tapLoginButton() {
    XCTContext.runActivity(named: "Нажать на кнопку \"Log in\"") { _ in
      app.buttons["loginButton"].tap()
    }
  }

  func tapLoginButtonInSuccessAlert() {
    XCTContext.runActivity(named: "Нажать на кнопку \"Log in\" в модальном окне") { _ in
      app.alerts["Congratulations!"].buttons["Log in"].tap()
    }
  }

  func tapCreateNewAccountButton() {
    XCTContext.runActivity(named: "Начать создание аккаунта") { _ in
      app.staticTexts["Create new account"].tap()
    }
  }

  func fillUserNameOnSignUpScreen(_ value: String) {
    XCTContext.runActivity(named: "Ввести \(value) в поле логина") { _ in
      let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
      let usernameField = signUpScreen.textFields["userNameTextField"]
      usernameField.tap()
      usernameField.typeText(value)
      app.keyboards.buttons["Return"].tap()
    }
  }

  func fillUserNameOnLoginScreen(_ value: String) {
    XCTContext.runActivity(named: "Ввести \(value) в поле логина") { _ in
      let loginScreen = app.otherElements.containing(.staticText, identifier: "Log in").element
      let loginField = loginScreen.textFields["userNameTextField"]
      loginField.tap()
      loginField.typeText(value)
      app.keyboards.buttons["Return"].tap()
    }
  }

  func fillPasswordOnLoginScreen(_ value: String) {
    XCTContext.runActivity(named: "Ввести \(value) в поле пароля") { _ in
      let loginScreen = app.otherElements.containing(.staticText, identifier: "Log in").element
      let passwordField = loginScreen.textFields["passwordTextField"]
      loginScreen.buttons["passwordTextField"].tap()
      passwordField.tap()
      passwordField.typeText(value)
      app.keyboards.buttons["Return"].tap()
    }
  }

  func fillPasswordOnSignUpScreen(_ value: String) {
    XCTContext.runActivity(named: "Ввести \(value) в поле пароля") { _ in
      let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
      signUpScreen.buttons["passwordTextField"].tap()
      let passwordField = signUpScreen.textFields["passwordTextField"]
      passwordField.tap()
      passwordField.typeText(value)
      app.keyboards.buttons["Return"].tap()
    }
  }

  func confirmPasswordOnSignUpScreen(_ value: String) {
    XCTContext.runActivity(named: "Ввести \(value) в поле подтверждения пароля") { _ in
      let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
      signUpScreen.buttons["confirmPasswordTextField"].tap()
      let confirmPasswordField = signUpScreen.textFields["confirmPasswordTextField"]
      confirmPasswordField.tap()
      confirmPasswordField.typeText(value)
      app.keyboards.buttons["Return"].tap()
    }
  }

  func tapSignUpButton() {
    XCTContext.runActivity(named: "Нажать на кнопку подтверждения регистрации") { _ in
      let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
      signUpScreen.buttons["Sign Up"].tap()
    }
  }

  func fillLoginForm(
    userName: String,
    password: String,
    submit: Bool = true,
    goToSignUp: Bool = false
  ) {
    XCTContext.runActivity(named: "Заполнить форму авторизации") { _ in
      fillUserNameOnLoginScreen(userName)
      fillPasswordOnLoginScreen(password)

      if submit {
        tapLoginButton()
        if goToSignUp {
          tapCreateNewAccountButton()
        }
      }
    }
  }

  func fillSignUpForm(
    userName: String,
    password: String,
    confirmPasswordValue: String,
    submit: Bool = true
  ) {
    XCTContext.runActivity(named: "Заполнить форму регистрации") { _ in
      fillUserNameOnSignUpScreen(userName)
      fillPasswordOnSignUpScreen(password)
      confirmPasswordOnSignUpScreen(confirmPasswordValue)

      if submit {
        tapSignUpButton()
      }
    }
  }

  func loginAsFreshUser(userName: String, password: String) {
    XCTContext.runActivity(named: "Авторизоваться под новым пользователем") { _ in
      registerUser(userName: userName, password: password)

      assertSuccessAlertShown()

      tapLoginButtonInSuccessAlert()
      tapLoginButton()
    }
  }

  func registerUser(userName: String, password: String) {

    XCTContext.runActivity(named: "Зарегистрировать пользователя") { _ in
      tapCreateNewAccountButton()

      fillSignUpForm(
        userName: userName,
        password: password,
        confirmPasswordValue: password
      )

      assertSuccessAlertShown()
    }
  }

  func assertSuccessAlertShown(file: StaticString = #filePath, line: UInt = #line) {
    XCTContext.runActivity(named: "Аккаунт создан") { _ in
      let isFound = app.alerts["Congratulations!"].waitForExistence(timeout: 30)
      XCTAssertTrue(isFound, "Не удалось создать аккаунт", file: file, line: line)
    }
  }

  func assertSignUpUserNameFieldEquals(
    _ value: String, file: StaticString = #filePath, line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Поле логина содержит \(value)") { _ in
      let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
      let usernameValue = signUpScreen.textFields["userNameTextField"].value as? String
      XCTAssertEqual(
        usernameValue,
        value,
        "В поле логина отображается неверный текст",
        file: file,
        line: line
      )
    }
  }

  func assertSignUpPasswordFieldEquals(
    _ value: String, file: StaticString = #filePath, line: UInt = #line
  ) {

    XCTContext.runActivity(named: "Поле пароля содержит \(value)") { _ in
      let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
      signUpScreen.buttons["passwordTextField"].tap()
      let passwordValue = signUpScreen.textFields["passwordTextField"].value as? String
      XCTAssertEqual(
        passwordValue,
        value,
        "В поле пароля отображается неверный текст",
        file: file,
        line: line
      )
    }
  }

  func assertSignUpFormPrefilled(
    userName: String,
    password: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "В форму регистрации перенесены данные из формы авторизации") {
      _ in
      assertSignUpUserNameFieldEquals(userName, file: file, line: line)
      assertSignUpPasswordFieldEquals(password)
    }
  }
}
