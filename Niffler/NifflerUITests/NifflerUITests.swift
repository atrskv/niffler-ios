import XCTest

final class NifflerUITests: XCTestCase {
    
    let userName = "testUserNameFoo"
    let password = "secret"
    
    var app: XCUIApplication!
    
    func testRegistration() throws {
        launchAppWithountLogin()
        
        startCreatingAccount()
        fillUserNameOnCreatingAccountScreen(userName)
        fillPasswordOnCreatingAccountScreen(password)
        confirmPassword(password)
        singUp()
        
        shouldHaveAccountCreated()
    }
    
    func testRegistrationFormIsPreFilledFromLoginData() throws {
        launchAppWithountLogin()
        
        fillUserNameOnLoginScreen(userName)
        fillPasswordOnLoginScreen(password)
        startCreatingAccount()
        
        shouldUserNameOnCreatingAccountScreenHaveText(userName)
        shouldPasswordOnCreatingAccountScreenHaveText(password)
    }
    
    private func launchAppWithountLogin() {
        XCTContext.runActivity(named: "Запустить приложение без авторизации") { _ in
            app = XCUIApplication()
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
    private func startCreatingAccount() {
        XCTContext.runActivity(named: "Начать создание аккаунта") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func fillUserNameOnCreatingAccountScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле логина") { _ in
            let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            let usernameField = registerScreen.textFields["userNameTextField"]
            usernameField.tap()
            usernameField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func fillUserNameOnLoginScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле логина") { _ in
            let loginScreen = app.otherElements.containing(.staticText, identifier: "Log in").element
            let loginField = loginScreen.textFields["userNameTextField"]
            loginField.tap()
            loginField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func fillPasswordOnLoginScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле пароля") { _ in
            let loginScreen = app.otherElements.containing(.staticText, identifier: "Log in").element
            let passwordField = loginScreen.textFields["passwordTextField"]
            loginScreen.buttons["passwordTextField"].tap()
            passwordField.tap()
            passwordField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func fillPasswordOnCreatingAccountScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле пароля") { _ in
            let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            registerScreen.buttons["passwordTextField"].tap()
            let passwordField = registerScreen.textFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func confirmPassword(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле подтверждения пароля") { _ in
            let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            registerScreen.buttons["confirmPasswordTextField"].tap()
            let confirmPasswordField = registerScreen.textFields["confirmPasswordTextField"]
            confirmPasswordField.tap()
            confirmPasswordField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func singUp() {
        XCTContext.runActivity(named: "Нажать на кнопку подтверждения регистрации") { _ in
            let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            registerScreen.buttons["Sign Up"].tap()
        }
    }
    
    private func shouldHaveAccountCreated(file: StaticString = #filePath, line: UInt = #line) {
      XCTContext.runActivity(named: "Аккаунт создан") { _ in
        let isFound = app.alerts["Congratulations!"].waitForExistence(timeout: 15)
        XCTAssertTrue(isFound, "Не удалось создать аккаунт", file: file, line: line)
      }
    }

    private func shouldUserNameOnCreatingAccountScreenHaveText(
      _ value: String, file: StaticString = #filePath, line: UInt = #line
    ) {
      XCTContext.runActivity(named: "Поле логина содержит \(value)") { _ in
        let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
        let usernameValue = registerScreen.textFields["userNameTextField"].value as? String
        XCTAssertEqual(
          usernameValue,
          value,
          "В поле логина отображается неверный текст",
          file: file,
          line: line
        )
      }
    }

    private func shouldPasswordOnCreatingAccountScreenHaveText(
      _ value: String, file: StaticString = #filePath, line: UInt = #line
    ) {
      XCTContext.runActivity(named: "Поле пароля содержит \(value)") { _ in
        let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
        registerScreen.buttons["passwordTextField"].tap()
        let passwordValue = registerScreen.textFields["passwordTextField"].value as? String
        XCTAssertEqual(
          passwordValue,
          value,
          "В поле пароля отображается неверный текст",
          file: file,
          line: line
        )
      }
    }
  }

