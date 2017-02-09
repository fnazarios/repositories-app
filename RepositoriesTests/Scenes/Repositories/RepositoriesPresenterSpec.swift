import Quick
import Nimble
@testable import Repositories

class RepositoriesPresenterSpec: QuickSpec {
    override func spec() {
        fdescribe("Repostories Presenter") {
            fcontext("search repositories") {
                let repo = Repository(id: 123, name: "Name", fullname: "Repo/Name", description: "Description repositori", starts: 10, forks: 10, owner: User(id: 1212, login: "fnazarios", avatarUrl: ""))
                let fakePresenterOutput = FakeRepositoriesPresenterOutput()
                beforeEach {
                    let presenter = RepositoriesPresenter()
                    presenter.output = fakePresenterOutput
                    presenter.presentSearchResult(RepositoriesResponse(repositories: [repo], error: nil))
                }
                
                fit("call output with viewModel") {
                    expect(fakePresenterOutput.displaySearchResultWasCalled).to(beTruthy())
                }
                
                fit("viewModel should not be nil") {
                    expect(fakePresenterOutput.repositoriesViewModel).toNot(beNil())
                }
                
                fit("viewModel.Repository name should be eq \(repo.name)") {
                    let viewModelRepository = fakePresenterOutput.repositoriesViewModel?.repositories?.first
                    expect(viewModelRepository?.name).to(equal(repo.name))
                }
                
                fit("viewModel.Repository countStars should be eq \(repo.starts)") {
                    let viewModelRepository = fakePresenterOutput.repositoriesViewModel?.repositories?.first
                    expect(viewModelRepository?.countStars).to(equal("\(repo.starts)"))
                }
            }
        }
    }
}

class FakeRepositoriesPresenterOutput: RepositoriesPresenterOutput {
    
    var displaySearchResultWasCalled: Bool = false
    var repositoriesViewModel: RepositoriesViewModel?
    
    func displaySearchResult(_ viewModel: RepositoriesViewModel) {
        self.displaySearchResultWasCalled = true
        self.repositoriesViewModel = viewModel
    }
    
    func displayResultWhenError(_ viewModel: RepositoriesViewModel) { }
}
