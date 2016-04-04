import XCTest
@testable import Repositories

class PullRequestsCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testShouldListPullRequests() {
        sleep(10)
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["RxJava"].tap()
        
        let title = app.navigationBars["ReactiveX/RxJava"].staticTexts["ReactiveX/RxJava"]
        XCTAssertNotNil(title)
        
        sleep(10)
        tablesQuery.cells.containingType(.StaticText, identifier:"1.x: make defensive copy of the properties in RxJavaPlugins").childrenMatchingType(.StaticText).matchingIdentifier("1.x: make defensive copy of the properties in RxJavaPlugins").elementBoundByIndex(0).swipeUp()
    }
}
