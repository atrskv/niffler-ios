import XCTest

class Page {

  let app: XCUIApplication

  init(app: XCUIApplication) {
    self.app = app
  }

  func expandMenu() {
    XCTContext.runActivity(named: "Раскрыть верхнее меню") { _ in
      let menuButton = app.images["ic_menu"]
      XCTAssertTrue(menuButton.waitForExistence(timeout: 5))
      menuButton.tap()
    }
  }

  func foldMenu(
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Закрыть верхнее меню") { _ in
      app.images["ic_cross"].tap()
    }
  }

  func openProfile() {
    XCTContext.runActivity(named: "Открыть профиль") { _ in
      expandMenu()
      let profileButton = app.buttons["Profile"]
      XCTAssertTrue(
        profileButton.waitForExistence(timeout: 5))
      profileButton.tap()
    }
  }
}

class ProfilePage: Page {

  func closeProfile(
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Закрыть профиль") { _ in
      app.buttons["Close"].tap()
    }
  }

  func removeCategory(
    name: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Удалить \(name)") { _ in
      let categoryCell = app.collectionViews.cells
        .containing(.staticText, identifier: name)
        .firstMatch
      XCTAssertTrue(
        categoryCell.waitForExistence(timeout: 5),
        "Категория \(name) не найдена",
        file: file,
        line: line
      )
      categoryCell.swipeLeft()
      app.buttons["Delete"].tap()
    }
  }

  func assertCategoryExists(
    name: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Категория \(name) существует") { _ in
      let category = app.staticTexts[name]
      XCTAssertTrue(
        category.waitForExistence(timeout: 5),
        "Категория \(name) не найдена",
        file: file,
        line: line
      )
    }
  }

  func assertCategoryNotExists(
    name: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Категория \(name) отсутствует") { _ in
      let category = app.collectionViews.staticTexts[name]
      XCTAssertFalse(
        category.exists,
        "Категория \(name) существует",
        file: file,
        line: line
      )
    }
  }

}

class LoginPage: Page {

  func loginAsFreshUser(userName: String, password: String, confirmPasswordValue: String) {
    XCTContext.runActivity(named: "Авторизоваться под новым пользователем") { _ in
      tapCreateNewAccountButton()

      fillSignUpForm(
        userName: userName,
        password: password,
        confirmPasswordValue: confirmPasswordValue
      )
      tapSignUpButton()

      assertSuccessAlertShown()

      tapLoginButtonInSuccessAlert()
      tapLoginButton()
    }
  }

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

  func fillLoginForm(userName: String, password: String) {
    XCTContext.runActivity(named: "Заполнить форму авторизации") { _ in
      fillUserNameOnLoginScreen(userName)
      fillPasswordOnLoginScreen(password)
      tapCreateNewAccountButton()
    }
  }

  func fillSignUpForm(
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

class SpendsPage: Page {

  func addNewCategory(_ name: String) {
    XCTContext.runActivity(named: "Добавить категорию") { _ in
      app.buttons["Select category"].tap()

      let addCategoryAlert = app.alerts["Add category"]
      addCategoryAlert.textFields["Name"].typeText(name)
      addCategoryAlert.buttons["Add"].tap()
    }
  }

  func tapAddSpendButton() {
    XCTContext.runActivity(named: "Нажать на кнопку добавления траты") { _ in
      app.buttons["addSpendButton"].tap()
    }
  }

  func addSpend(
    amount: String, description: String, categoryName: String? = nil
  ) {
    XCTContext.runActivity(named: "Добавить трату") { _ in
      let spendsCount = app.otherElements
        .matching(identifier: "spendsList")
        .count

      tapAddSpendButton()

      let categoryToUse: String

      if let categoryName {
        categoryToUse = categoryName
      } else {
        categoryToUse = "cat_\(UUID().uuidString.prefix(3))"
      }

      if spendsCount == 0 {
        addNewCategory(categoryToUse)
      }

      app.textFields["amountField"].typeText(amount)
      app.textFields["descriptionField"].tap()
      app.textFields["descriptionField"].typeText(description)
      app.buttons["Add"].tap()
    }
  }

  func assertSpendExists(
    amount: String,
    description: String,
    currency: String = "₸",
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTContext.runActivity(named: "Трата создана") {
      _ in

      let spendItem = app.otherElements
        .matching(identifier: "spendsList")
        .containing(.staticText, identifier: description)
        .firstMatch

      XCTAssertTrue(
        spendItem.staticTexts["\(currency)\(amount)"].exists,
        "Трата не создана",
        file: file,
        line: line
      )
    }
  }

  func assertNoCategoriesForSelect(file: StaticString = #filePath, line: UInt = #line) {
    XCTContext.runActivity(named: "Отсутствуют категории для выбора") { _ in
      let categoryButton = app.buttons["Select category"]
      XCTAssertEqual(
        categoryButton.label, "+ New category", "Кнопка должна показывать '+ New category'",
        file: file, line: line)
    }
  }

  func assertStatisticsScreenShown(file: StaticString = #filePath, line: UInt = #line) {
    XCTContext.runActivity(named: "Пользователь находится на экране \"Statistics\"") { _ in
      let isFound = app.staticTexts["Statistics"].waitForExistence(timeout: 30)
      XCTAssertTrue(isFound, "Не удалось перейти к экрану \"Statistics\"", file: file, line: line)
    }
  }
}

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
