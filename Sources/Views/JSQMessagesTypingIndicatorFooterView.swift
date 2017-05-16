//
//  JSQMessagesTypingIndicatorFooterView.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesTypingIndicatorFooterView: UICollectionReusableView {
    
    static var kJSQMessagesTypingIndicatorFooterViewHeight: CGFloat = 46
    
    @IBOutlet var animationView: UIView!
    
    open class func nib() -> UINib {
    
        return UINib(nibName: JSQMessagesTypingIndicatorFooterView.jsq_className, bundle: Bundle(for: JSQMessagesTypingIndicatorFooterView.self))
    }
    
    open class func footerReuseIdentifier() -> String {
        
        return JSQMessagesTypingIndicatorFooterView.jsq_className
    }
    
    // MARK: - Initialization
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        
        self.setupAnimation()
    }
    
    // MARK: - Reusable view
    
    open override var backgroundColor: UIColor? {
        
        didSet {
        
        }
    }
    
    // MARK: - Typing indicator
    func configure( ) {

    }
    
    private func setupAnimation() {
        let tp = JSQTypingAnimation()
        var animationRect = UIEdgeInsetsInsetRect(self.animationView.frame, UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        let minEdge = min(animationRect.width, animationRect.height)
        animationRect.size = CGSize(width: minEdge, height: minEdge)

        self.animationView.layer.speed = 1
        self.animationView.layer.sublayers?.removeAll()
        tp.setUpAnimation(in: self.animationView.layer, size: animationRect.size , color: UIColor.lightGray)
    }
}
