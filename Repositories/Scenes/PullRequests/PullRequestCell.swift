import UIKit
import Nuke

class PullRequestCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userAvatarView: UIAvatarView!
    
    func configure(_ pullRequest: PullRequestsViewModel.PullRequest) {
        self.titleLabel?.text = pullRequest.title
        self.bodyLabel.text = pullRequest.body
        self.createdAtLabel.text = pullRequest.createdAt
        self.userUsernameLabel.text = pullRequest.userUsername
        
        Nuke.loadImage(with: URL(string: pullRequest.userAvatarUrl)!, into: self.userAvatarView.imgAvatar)
    }
}
