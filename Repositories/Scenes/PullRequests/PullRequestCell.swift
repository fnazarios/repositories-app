import UIKit
import Nuke

class PullRequestCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userAvatarView: UIAvatarView!
    
    func configure(pullRequest: PullRequestsViewModel.PullRequest) {
        self.titleLabel?.text = pullRequest.title
        self.bodyLabel.text = pullRequest.body
        self.createdAtLabel.text = pullRequest.createdAt
        self.userUsernameLabel.text = pullRequest.userUsername
        self.userAvatarView.imgAvatar.nk_setImageWith(NSURL(string: pullRequest.userAvatarUrl)!)
    }
}
