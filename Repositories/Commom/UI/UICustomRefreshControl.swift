import UIKit

public class UICustomRefreshControl: UIRefreshControl {
    
    public override init () {
        super.init()
        self.attributedTitle = NSAttributedString(string: "Refresh")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(inView view: UIView, target: AnyObject, action: Selector) {
        self.addTarget(target, action: action, forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(self)
        
        view.sendSubviewToBack(self)
    }
    
    public func beginLoading() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.attributedTitle = NSAttributedString(string: NSLocalizedString("Refreshing...", comment: ""))
        self.beginRefreshing()
    }
    
    public func endLoading() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.attributedTitle = NSAttributedString(string: String(format: NSLocalizedString("Refreshed at %@", comment: ""), NSDate.dateToString(NSDate())!))
        self.endRefreshing()
    }
}