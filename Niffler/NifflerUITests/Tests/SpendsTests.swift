import XCTest

final class SpendsTests: BaseTestCase {

  let amount = "\(Int.random(in: 100...999))"
  let spendDescription = "cat_\(UUID().uuidString.prefix(3))"
  let userName = "user_\(UUID().uuidString.prefix(3))"
  let password = "pass_\(UUID().uuidString.prefix(3))"
  let category = "cat_\(UUID().uuidString.prefix(3))"

  func testAddSpend() throws {
    loginPage.loginAsFreshUser(userName: userName, password: password)

    spendsPage
      .addSpend(amount: amount, description: spendDescription, category: category)
      .assertSpendExists(amount: amount, description: spendDescription)
      .openProfile()

    profilePage.assertCategoryExists(name: category)
  }

  func testRemoveSpendsCategory() throws {
    loginPage.loginAsFreshUser(userName: userName, password: password)
    spendsPage
      .addSpend(amount: amount, description: spendDescription, category: category)

      .openProfile()
    profilePage
      .removeCategory(name: category)
      .assertCategoryNotExists(name: category)
      .closeProfile()

    spendsPage
      .tapAddSpendButton()
      .assertNoCategoriesForSelect()
  }
}
