import XCTest

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
