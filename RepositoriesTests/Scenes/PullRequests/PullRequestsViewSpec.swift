import Quick
import Nimble
@testable import Repositories

class PullRequestsViewSpec: QuickSpec {
    override func spec() {
        fdescribe("PullRequests View Controller") {
            fcontext("load view") {
                let repository = Repository(id: 20506004, name: "Quick", fullname: "Quick/Quick", description: "The Swift (and Objective-C) testing framework.", starts: 4429, forks: 417, owner: User(id: 8083968, login: "Quick", avatarUrl: "https://avatars.githubusercontent.com/u/8083968?v=3"))
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pullRequestsViewController = storyboard.instantiateViewController(withIdentifier: "PullRequestsViewController") as! PullRequestsViewController
                pullRequestsViewController.output.repository = repository
                
                beforeEach {
                    pullRequestsViewController.loadView()
                    let _ = pullRequestsViewController.view
                    pullRequestsViewController.viewDidLoad()
                }
                
                fit("router should not be nil") {
                    expect(pullRequestsViewController.router).toNot(beNil())
                }
                
                fit("output should not be nil") {
                    expect(pullRequestsViewController.output).toNot(beNil())
                }
                
                fit("title should be eq \(repository.fullname)") {
                    expect(pullRequestsViewController.title).to(equal(repository.fullname))
                }
                
                fit("started refresh pullRequests") {
                    expect(pullRequestsViewController.refreshControl.isRefreshing).to(beTruthy())
                }
            }
        }
    }
}
