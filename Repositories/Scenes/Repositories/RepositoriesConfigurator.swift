import UIKit

// MARK: Connect View, Interactor, and Presenter
extension RepositoriesViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.router.passDataToNextScene(segue)
    }
}

extension RepositoriesInteractor: RepositoriesViewControllerOutput { }

extension RepositoriesPresenter: RepositoriesInteractorOutput { }

class RepositoriesConfigurator {
    // MARK: Object lifecycle
    class var sharedInstance: RepositoriesConfigurator {
        struct Static {
            static var instance: RepositoriesConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = RepositoriesConfigurator()
        }
        
        return Static.instance!
    }
    
    // MARK: Configuration
    func configure(viewController: RepositoriesViewController) {
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
