//
//  JSQMessagesMediaPlaceholderView.swift
//  JSQMessagesViewController
//
//

import UIKit

class JSQMessagesMediaPlaceholderView: UIView {
    
    fileprivate(set) var activityIndicatorView: UIActivityIndicatorView?
    fileprivate(set) var imageView: UIImageView?
    
    // MARK: - Init
    
    class func viewWithActivityIndicator() -> JSQMessagesMediaPlaceholderView {
        
        let lightGrayColor = UIColor.jsq_messageBubbleLightGrayColor()
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.color = UIColor.darkGray
        
        return JSQMessagesMediaPlaceholderView(frame: CGRect(x: 0, y: 0, width: 200, height: 120), backgroundColor: lightGrayColor, activityIndicatorView: spinner)
    }
    
    class func viewWithAttachmentIcon() -> JSQMessagesMediaPlaceholderView {
        
        let lightGrayColor = UIColor.jsq_messageBubbleLightGrayColor()
        let paperClip = UIImage.jsq_defaultAccessoryImage()?.jsq_imageMaskedWithColor(lightGrayColor.jsq_colorByDarkeningColorWithValue(0.4))
        let imageView = UIImageView(image: paperClip)
        
        return JSQMessagesMediaPlaceholderView(frame: CGRect(x: 0, y: 0, width: 200, height: 120), backgroundColor: lightGrayColor, imageView: imageView)
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor, activityIndicatorView: UIActivityIndicatorView) {
        
        self.init(frame: frame, backgroundColor: backgroundColor)
        
        self.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.center = self.center
        activityIndicatorView.startAnimating()
        
        self.imageView = nil
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor, imageView: UIImageView) {
        
        self.init(frame: frame, backgroundColor: backgroundColor)
        
        self.addSubview(imageView)
        self.imageView = imageView
        imageView.center = self.center
        
        self.activityIndicatorView = nil
    }
    
    init(frame: CGRect, backgroundColor: UIColor) {
        
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
    
        super.layoutSubviews()
        
        if let activityIndicatorView = self.activityIndicatorView {
            
            activityIndicatorView.center = self.center
        }
        else if let imageView = self.imageView {
            
            imageView.center = self.center
        }
    }
}
