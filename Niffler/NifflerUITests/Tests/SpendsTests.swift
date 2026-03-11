import XCTest

final class SpendsTests: BaseTestCase {

  let randomSpendAmount = "\(Int.random(in: 100...999))"
  let randomSpendDescription = "cat_\(UUID().uuidString.prefix(3))"
  let randomUserName = "user_\(UUID().uuidString.prefix(3))"
  let randomPassword = "pass_\(UUID().uuidString.prefix(3))"
  let randomCategoryName = "cat_\(UUID().uuidString.prefix(3))"

  func testAddSpend() throws {

    // GIVEN
    loginPage.loginAsFreshUser(userName: randomUserName, password: randomPassword)

    // WHEN
    spendsPage
      .addSpend(
        amount: randomSpendAmount, description: randomSpendDescription,
        categoryName: randomCategoryName
      )

      // THEN
      .assertSpendExists(amount: randomSpendAmount, description: randomSpendDescription)

      // WHEN
      .openProfile()

    // THEN
    profilePage.assertCategoryExists(name: randomCategoryName)

  }

  func testRemoveSpendsCategory() throws {

    // GIVEN
    loginPage.loginAsFreshUser(userName: randomUserName, password: randomPassword)
    spendsPage.addSpend(
      amount: randomSpendAmount, description: randomSpendDescription,
      categoryName: randomCategoryName
    )

    // WHEN
    .openProfile()

    profilePage.removeCategory(name: randomCategoryName)

      // THEN
      .assertCategoryNotExists(name: randomCategoryName)

    // WHEN
    profilePage
      .closeProfile()
    spendsPage
      .tapAddSpendButton()

      // THEN
      .assertNoCategoriesForSelect()
  }
}
