import XCTest

final class SpendsTests: TestCase {

  let randomSpendAmount = "\(Int.random(in: 100...999))"
  let randomSpendDescription = "cat_\(UUID().uuidString.prefix(3))"
  let randomUserName = "user_\(UUID().uuidString.prefix(3))"
  let randomPassword = "pass_\(UUID().uuidString.prefix(3))"
  let randomCategoryName = "cat_\(UUID().uuidString.prefix(3))"

  var loginPage: LoginPage!
  var spendsPage: SpendsPage!
  var profilePage: ProfilePage!

  override func setUp() {
    super.setUp()
    loginPage = LoginPage(app: app)
    spendsPage = SpendsPage(app: app)
    profilePage = ProfilePage(app: app)
  }

  func testAddSpend() throws {

    // GIVEN
    loginPage.loginAsFreshUser(
      userName: randomUserName,
      password: randomPassword,
    )
    spendsPage.assertStatisticsScreenShown()

    // WHEN
    spendsPage.addSpend(
      amount: randomSpendAmount,
      description: randomSpendDescription,
      categoryName: randomCategoryName
    )

    // THEN
    spendsPage.assertStatisticsScreenShown()
    spendsPage.assertSpendExists(
      amount: randomSpendAmount,
      description: randomSpendDescription
    )

    // WHEN
    spendsPage.openProfile()

    // THEN
    profilePage.assertCategoryExists(name: randomCategoryName)

  }

  func testRemoveSpendsCategory() throws {

    // GIVEN
    loginPage.loginAsFreshUser(
      userName: randomUserName,
      password: randomPassword,
    )
    spendsPage.assertStatisticsScreenShown()

    spendsPage.addSpend(
      amount: randomSpendAmount,
      description: randomSpendDescription,
      categoryName: randomCategoryName
    )

    // WHEN
    spendsPage.openProfile()
    profilePage.removeCategory(name: randomCategoryName)

    // THEN
    profilePage.assertCategoryNotExists(name: randomCategoryName)

    // WHEN
    profilePage.closeProfile()
    profilePage.foldMenu()
    spendsPage.assertStatisticsScreenShown()
    spendsPage.tapAddSpendButton()

    // THEN
    spendsPage.assertNoCategoriesForSelect()
  }
}
