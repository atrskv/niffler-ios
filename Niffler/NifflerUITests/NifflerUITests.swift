import XCTest

final class NifflerUITests: XCTestCase {
    
    let randomUserName = "user_\(UUID().uuidString.prefix(3))"
    let randomPassword = "pass_\(UUID().uuidString.prefix(3))"
    
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
    
    func testRegistration() throws {
        tapCreateNewAccountButton()
        
        fillSignUpForm(
            userName: randomUserName,
            password: randomPassword,
            confirmPasswordValue: randomPassword
        )
        tapSignUpButton()
        
        assertSuccessAlertShown()
    }
    
    func testRegistrationFormIsPreFilledFromLoginData() throws {
        fillLoginForm(
            userName: randomUserName,
            password: randomPassword
        )
        
        assertSignUpFormPrefilled(
            userName: randomUserName,
            password: randomPassword
        )
    }
        
    private func tapCreateNewAccountButton() {
        XCTContext.runActivity(named: "Начать создание аккаунта") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func fillUserNameOnSignUpScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле логина") { _ in
            let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            let usernameField = signUpScreen.textFields["userNameTextField"]
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
    
    private func fillPasswordOnSignUpScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле пароля") { _ in
            let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            signUpScreen.buttons["passwordTextField"].tap()
            let passwordField = signUpScreen.textFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func confirmPasswordOnSignUpScreen(_ value: String) {
        XCTContext.runActivity(named: "Ввести \(value) в поле подтверждения пароля") { _ in
            let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            signUpScreen.buttons["confirmPasswordTextField"].tap()
            let confirmPasswordField = signUpScreen.textFields["confirmPasswordTextField"]
            confirmPasswordField.tap()
            confirmPasswordField.typeText(value)
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func tapSignUpButton() {
        XCTContext.runActivity(named: "Нажать на кнопку подтверждения регистрации") { _ in
            let signUpScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            signUpScreen.buttons["Sign Up"].tap()
        }
    }
    
    private func fillLoginForm(userName: String, password: String) {
        XCTContext.runActivity(named: "Заполнить форму авторизации") { _ in
            fillUserNameOnLoginScreen(userName)
            fillPasswordOnLoginScreen(password)
            tapCreateNewAccountButton()
        }
    }
    
    private func fillSignUpForm(
        userName: String,
        password: String,
        confirmPasswordValue: String
    ) {
        XCTContext.runActivity(named: "Заполнить форму регистрации") { _ in
            fillUserNameOnSignUpScreen(userName)
            fillPasswordOnSignUpScreen(password)
            confirmPasswordOnSignUpScreen(confirmPasswordValue)
        }
    }
        
    private func assertSuccessAlertShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Аккаунт создан") { _ in
            let isFound = app.alerts["Congratulations!"].waitForExistence(timeout: 30)
            XCTAssertTrue(isFound, "Не удалось создать аккаунт", file: file, line: line)
        }
    }
    
    private func assertSignUpUserNameFieldEquals(
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
    
    private func assertSignUpPasswordFieldEquals(
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
    
    private func assertSignUpFormPrefilled(
        userName: String,
        password: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTContext.runActivity(named: "В форму регистрации перенесены данные из формы авторизации") { _ in
            assertSignUpUserNameFieldEquals(userName, file: file, line: line)
            assertSignUpPasswordFieldEquals(password)
        }
    }
}
