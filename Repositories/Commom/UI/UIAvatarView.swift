import UIKit

@IBDesignable
class UIAvatarView: UIView {
    
    var imgAvatar: UIImageView! = UIImageView()
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.CGColor
        }
    }
    
    @IBInspectable
    var image: UIImage? = UIImage(named: "person_placeholder") {
        didSet {
            self.imgAvatar.image = image
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imgAvatar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.imgAvatar.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imgAvatar)
    }
    
}
