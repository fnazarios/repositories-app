import XCTest
@testable import Repositories

class RepositoriesCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldListRepostoriesInJava() {
        sleep(4)
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["retrofit"].swipeUp()
        tablesQuery.staticTexts["okhttp"].swipeUp()
        tablesQuery.staticTexts["MPAndroidChart"].swipeUp()
        tablesQuery.staticTexts["RxAndroid"].swipeUp()
        tablesQuery.staticTexts["glide"].swipeUp()
        tablesQuery.staticTexts["EventBus"].swipeUp()
    }
    
}
