import Quick
import Nimble
@testable import Repositories

class PullRequestsPresenterSpec: QuickSpec {
    override func spec() {
        fdescribe("PullRequests Presenter") {
            fcontext("diplay pull requests") {
                let pullRequest = PullRequest(id: 64199285, title: "Fixed redirect with completion property not being called", body: "The new completion properties weren't getting called due to the bad `respondsToSelector` check.", createdAt: NSDate(), url: "", user: User(id: 1, login: "spec", avatarUrl: ""))
                let fakePresenterOutput = FakePullRequestsPresenterOutput()
                beforeEach {
                    let presenter = PullRequestsPresenter()
                    presenter.output = fakePresenterOutput
                    presenter.presentPullRequests(PullRequestsResponse(pullRequests: [pullRequest], error: nil))
                }
                
                fit("call output with viewModel") {
                    expect(fakePresenterOutput.displayPullRequestsWasCalled).to(beTruthy())
                }
                
                fit("viewModel should not be nil") {
                    expect(fakePresenterOutput.pullRequestsViewModel).toNot(beNil())
                }
                
                fit("viewModel.PullRequest title should be eq \(pullRequest.title)") {
                    let viewModelPullRequest = fakePresenterOutput.pullRequestsViewModel?.pullRequests?.first
                    expect(viewModelPullRequest?.title).to(equal(pullRequest.title))
                }
                
                fit("viewModel.PullRequest userUsername should be eq \(pullRequest.user.login)") {
                    let viewModelPullRequest = fakePresenterOutput.pullRequestsViewModel?.pullRequests?.first
                    expect(viewModelPullRequest?.userUsername).to(equal(pullRequest.user.login))
                }
            }
        }
    }
}

class FakePullRequestsPresenterOutput: PullRequestsPresenterOutput {
    
    var displayPullRequestsWasCalled: Bool = false
    var pullRequestsViewModel: PullRequestsViewModel?
    
    func displayPullRequests(viewModel: PullRequestsViewModel) {
        self.displayPullRequestsWasCalled = true
        self.pullRequestsViewModel = viewModel
    }
    
    func displayPullRequestsWhenError(viewModel: PullRequestsViewModel) { }
}
