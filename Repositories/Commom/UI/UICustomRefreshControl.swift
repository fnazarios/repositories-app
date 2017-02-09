import UIKit

open class UICustomRefreshControl: UIRefreshControl {
    
    public override init () {
        super.init()
        self.attributedTitle = NSAttributedString(string: "Refresh")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(inView view: UIView, target: AnyObject, action: Selector) {
        self.addTarget(target, action: action, for: UIControlEvents.valueChanged)
        view.addSubview(self)
        
        view.sendSubview(toBack: self)
    }
    
    open func beginLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.attributedTitle = NSAttributedString(string: NSLocalizedString("Refreshing...", comment: ""))
        self.beginRefreshing()
    }
    
    open func endLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.attributedTitle = NSAttributedString(string: String(format: NSLocalizedString("Refreshed at %@", comment: ""), Date.dateToString(Date())!))
        self.endRefreshing()
    }
}
