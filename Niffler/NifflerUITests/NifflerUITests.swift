import XCTest

final class NifflerUITests: XCTestCase {
        
    let app = XCUIApplication()
    let login = "testLoginYetAnother"
    let password = "secret"


        func testRegistration() throws {
            // GIVEN
            app.launch()

            // WHEN
            app.staticTexts["Create new account"].tap()
            let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            
            let usernameField = registerScreen.textFields["userNameTextField"]
            usernameField.tap()
            usernameField.typeText(login)
            app.keyboards.buttons["Return"].tap()
                        
            registerScreen.buttons["passwordTextField"].tap()
            let passwordField = registerScreen.textFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(password)
            app.keyboards.buttons["Return"].tap()
            
            registerScreen.buttons["confirmPasswordTextField"].tap()
            let confirmPasswordField = registerScreen.textFields["confirmPasswordTextField"]
            confirmPasswordField.tap()
            confirmPasswordField.typeText(password)
            app.keyboards.buttons["Return"].tap()
            
            registerScreen.buttons["Sign Up"].tap()
            
            // THEN
            XCTAssertTrue(app.alerts["Congratulations!"].waitForExistence(timeout: 15))
        }
        
        func testRegistrationFromLoginFormData() throws {
            // GIVEN
            app.launch()
            
            // WHEN
            let loginScreen = app.otherElements.containing(.staticText, identifier: "Log in").element

            let loginField = loginScreen.textFields["userNameTextField"]
            loginField.tap()
            loginField.typeText(login)
            app.keyboards.buttons["Return"].tap()
            
            let passwordField = loginScreen.textFields["passwordTextField"]
        
            loginScreen.buttons["passwordTextField"].tap()
            passwordField.tap()
            passwordField.typeText(password)
            app.keyboards.buttons["Return"].tap()
            
            // THEN
            app.staticTexts["Create new account"].tap()
            
            let registerScreen = app.otherElements.containing(.staticText, identifier: "Sign Up").element
            
            let usernameValue = registerScreen.textFields["userNameTextField"].value as? String
            XCTAssertEqual(usernameValue, login)
            
            registerScreen.buttons["passwordTextField"].tap()
            let passwordValue = registerScreen.textFields["passwordTextField"].value as? String
            XCTAssertEqual(passwordValue, password)
        }
    }
    
