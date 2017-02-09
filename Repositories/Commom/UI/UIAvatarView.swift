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
            self.layer.borderColor = borderColor?.cgColor
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
        
        self.imgAvatar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.imgAvatar.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(self.imgAvatar)
    }
    
}
