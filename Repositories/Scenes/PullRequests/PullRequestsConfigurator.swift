import UIKit

// MARK: Connect View, Interactor, and Presenter
extension PullRequestsViewController: PullRequestsPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router.passDataToNextScene(segue)
    }
}

extension PullRequestsInteractor: PullRequestsViewControllerOutput {
}

extension PullRequestsPresenter: PullRequestsInteractorOutput {
}

class PullRequestsConfigurator {
    static let sharedInstance: PullRequestsConfigurator = PullRequestsConfigurator()
    
    // MARK: Configuration
    
    func configure(_ viewController: PullRequestsViewController) {
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
