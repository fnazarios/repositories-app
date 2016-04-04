import UIKit

// MARK: Connect View, Interactor, and Presenter
extension PullRequestsViewController: PullRequestsPresenterOutput {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.router.passDataToNextScene(segue)
    }
}

extension PullRequestsInteractor: PullRequestsViewControllerOutput {
}

extension PullRequestsPresenter: PullRequestsInteractorOutput {
}

class PullRequestsConfigurator {
    // MARK: Object lifecycle
    class var sharedInstance: PullRequestsConfigurator {
        struct Static {
            static var instance: PullRequestsConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PullRequestsConfigurator()
        }
        
        return Static.instance!
    }
    
    // MARK: Configuration
    
    func configure(viewController: PullRequestsViewController) {
        let router = PullRequestsRouter()
        router.viewController = viewController
        
        let presenter = PullRequestsPresenter()
        presenter.output = viewController
        
        let interactor = PullRequestsInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
