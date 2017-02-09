import Quick
import Nimble
@testable import Repositories

class PullRequestsInteractorSpec: QuickSpec {
    override func spec() {
        fdescribe("PullRequests Interactor") {
            fcontext("fetch pull requests") {
                let fakeInteractor = FakePullRequestsInteractorOutput()
                let interactor = PullRequestsInteractor()
                beforeEach {
                    let repository = Repository(id: 20506004, name: "Quick", fullname: "Quick/Quick", description: "The Swift (and Objective-C) testing framework.", starts: 4429, forks: 417, owner: User(id: 8083968, login: "Quick", avatarUrl: "https://avatars.githubusercontent.com/u/8083968?v=3"))
                    
                    interactor.output = fakeInteractor
                    interactor.repository = repository
                    interactor.fetchPullRequests(PullRequestsRequest(page: 1))
                }
                
                fit("call output with response") {
                    expect(fakeInteractor.presentPullRequestsWasCalled).toEventually(beTruthy(), timeout: 10, pollInterval: 10, description: nil)
                }
                
                fit("pullRequests list should not be empty") {
                    expect(interactor.pullRequests).toEventuallyNot(beEmpty(), timeout: 10, pollInterval: 10, description: nil)
                }
            }
        }
    }
}

class FakePullRequestsInteractorOutput: PullRequestsInteractorOutput {
    
    var presentPullRequestsWasCalled: Bool = false
    func presentPullRequests(_ response: PullRequestsResponse) {
        self.presentPullRequestsWasCalled = true
    }
    
    func presentPullRequestsWhenError(_ response: PullRequestsResponse) { }
}
