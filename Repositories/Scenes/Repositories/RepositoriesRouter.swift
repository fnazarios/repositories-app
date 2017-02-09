import UIKit

protocol RepositoriesRouterInput {
    
}

class RepositoriesRouter: RepositoriesRouterInput {
    weak var viewController: RepositoriesViewController!
    
    // MARK: Navigation

    // MARK: Communication
    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        if segue.identifier == "SEGUE_SHOW_PRS" {
            self.passRepositoryToPullRequestsScene(segue)
        }
    }
    
    func passRepositoryToPullRequestsScene(_ segue: UIStoryboardSegue) {
        if let indexPathSelected = viewController.repositoriesTableView.indexPathForSelectedRow {
            let pullRequestsViewController = segue.destination as! PullRequestsViewController
            pullRequestsViewController.output.repository = self.viewController.output.repositories?[indexPathSelected.row]
        }
    }
}
