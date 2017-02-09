import Quick
import Nimble
@testable import Repositories

class RepositoriesViewSpec: QuickSpec {
    override func spec() {
        fdescribe("Repoditories View Controller") {
            fcontext("load view") {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let repositoriesViewController = (storyboard.instantiateInitialViewController() as! UINavigationController).topViewController as! RepositoriesViewController
                
                beforeEach {
                    repositoriesViewController.loadView()
                    let _ = repositoriesViewController.view
                    repositoriesViewController.viewDidLoad()
                }
                
                fit("router should not be nil") {
                    expect(repositoriesViewController.router).toNot(beNil())
                }
                
                fit("output should not be nil") {
                    expect(repositoriesViewController.output).toNot(beNil())
                }
                
                fit("title view should be eq Repositories") {
                    expect(repositoriesViewController.title).to(equal("Repositories"))
                }
                
                fit("started refresh repositories") {
                    expect(repositoriesViewController.refreshControl.isRefreshing).to(beTruthy())
                }
            }
        }
    }
}
