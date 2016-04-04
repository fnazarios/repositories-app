import UIKit
import RxSwift

class DefaultListViewController: UIViewController {

    var refreshControl: UICustomRefreshControl!
    
    lazy var disposeBag = DisposeBag()
    lazy var appDelegate: AppDelegate? = UIApplication.sharedApplication().delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UICustomRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
    }
    
    func startLoading() {
        self.refreshControl.beginLoading()
    }
    
    func endLoading() {
        self.refreshControl.endLoading()
    }
}