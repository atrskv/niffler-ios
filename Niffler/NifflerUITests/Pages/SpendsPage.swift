import XCTest

class SpendsPage: BasePage {

  @discardableResult
  func addNewCategory(_ name: String) -> Self {
    XCTContext.runActivity(named: "Добавить категорию") { _ in
      app.buttons["Select category"].tap()

      let addCategoryAlert = app.alerts["Add category"]
      addCategoryAlert.textFields["Name"].typeText(name)
      addCategoryAlert.buttons["Add"].tap()
    }
    return self
  }

  @discardableResult
  func tapAddSpendButton() -> Self {
    XCTContext.runActivity(named: "Нажать на кнопку добавления траты") { _ in
      app.buttons["addSpendButton"].tap()
    }
    return self
  }

  @discardableResult
  func addSpend(
    amount: String, description: String, category: String? = nil,
    file: StaticString = #filePath, line: UInt = #line
  ) -> Self {
    XCTContext.runActivity(named: "Добавить трату") { _ in
      let spendsCount = app.otherElements
        .matching(identifier: "spendsList")
        .count

      tapAddSpendButton()

      let categoryToUse: String

      if let category {
        categoryToUse = category
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

      let isFound = app.staticTexts["Statistics"].waitForExistence(timeout: 30)
      XCTAssertTrue(
        isFound, "Не удалось авторизоваться под новым пользователем", file: file, line: line)
    }
    return self
  }

  func assertSpendExists(
    amount: String,
    description: String,
    currency: String = "₸",
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> Self {
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
    return self
  }

  @discardableResult
  func assertNoCategoriesForSelect(file: StaticString = #filePath, line: UInt = #line) -> Self {
    XCTContext.runActivity(named: "Отсутствуют категории для выбора") { _ in
      let categoryButton = app.buttons["Select category"]
      XCTAssertEqual(
        categoryButton.label, "+ New category", "Кнопка должна показывать '+ New category'",
        file: file, line: line)
    }
    return self
  }

}
