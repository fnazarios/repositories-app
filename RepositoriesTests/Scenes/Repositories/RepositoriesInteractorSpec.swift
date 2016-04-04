import Quick
import Nimble
@testable import Repositories

class RepositoriesInteractorSpec: QuickSpec {
    override func spec() {
        fdescribe("Repostories Interactor") {
            fcontext("search repositories") {
                let fakeInteractor = FakeRepositoriesInteractorOutput()
                beforeEach {
                    let interactor = RepositoriesInteractor()
                    interactor.output = fakeInteractor
                    interactor.searchRepositories(withRequest: RepositoriesRequest(withLanguage: "Swift"))
                }
                
                fit("call output with response") {
                    expect(fakeInteractor.presentSearchResultWasCalled).toEventually(beTruthy(), timeout: 10, pollInterval: 10, description: nil)
                }
            }
        }
    }
}

class FakeRepositoriesInteractorOutput: RepositoriesInteractorOutput {
    
    var presentSearchResultWasCalled: Bool = false
    
    func presentSearchResult(response: RepositoriesResponse) {
        self.presentSearchResultWasCalled = true
    }
    
    func presentResultWhenError(response: RepositoriesResponse) { }
}
