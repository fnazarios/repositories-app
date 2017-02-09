import UIKit

// MARK: Connect View, Interactor, and Presenter
extension RepositoriesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router.passDataToNextScene(segue)
    }
}

extension RepositoriesInteractor: RepositoriesViewControllerOutput { }

extension RepositoriesPresenter: RepositoriesInteractorOutput { }

class RepositoriesConfigurator {

    static let sharedInstance: RepositoriesConfigurator = RepositoriesConfigurator()
    
    // MARK: Configuration
    func configure(_ viewController: RepositoriesViewController) {
        let router = RepositoriesRouter()
        router.viewController = viewController
        
        let presenter = RepositoriesPresenter()
        presenter.output = viewController
        
        let interactor = RepositoriesInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
