import UIKit
import Nuke

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var repositoryCountForksLabel: UILabel!
    @IBOutlet weak var repositoryCountStarsLabel: UILabel!
    @IBOutlet weak var ownerUsernameLabel: UILabel!
    @IBOutlet weak var ownerFullnameLabel: UILabel!
    @IBOutlet weak var ownerAvatarView: UIAvatarView!
    
    func configure(_ repository: RepositoriesViewModel.Repository) {
        self.repositoryNameLabel?.text = repository.name
        self.repositoryDescriptionLabel.text = repository.description
        self.repositoryCountForksLabel.text = repository.countForks
        self.repositoryCountStarsLabel.text = repository.countStars
        self.ownerUsernameLabel.text = repository.ownerUsername
        self.ownerFullnameLabel.text = repository.ownerFullname
        
        Nuke.loadImage(with: URL(string: repository.ownerAvatarUrl)!, into: self.ownerAvatarView.imgAvatar)
    }
}
