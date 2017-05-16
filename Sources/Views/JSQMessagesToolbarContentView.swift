//
//  JSQMessagesToolbarContentView.swift
//  JSQMessagesViewController
//
//

import UIKit

let kJSQMessagesToolbarContentViewHorizontalSpacingDefault: CGFloat = 8;

open class JSQMessagesToolbarContentView: UIView {
    
    @IBOutlet fileprivate(set) open var textView: JSQMessagesComposerTextView!
    
    @IBOutlet var leftBarButtonContainerView: UIView!
    @IBOutlet var leftBarButtonContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var rightBarButtonContainerView: UIView!
    @IBOutlet var rightBarButtonContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var leftHorizontalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var rightHorizontalSpacingConstraint: NSLayoutConstraint!
    
    open override var backgroundColor: UIColor? {
        
        didSet {
            
            self.leftBarButtonContainerView?.backgroundColor = backgroundColor
            self.rightBarButtonContainerView?.backgroundColor = backgroundColor
        }
    }
    
    open dynamic var leftBarButtonItem: UIButton? {
        
        willSet {
            
            self.leftBarButtonItem?.removeFromSuperview()

            if let newValue = newValue {
                
                if newValue.frame.equalTo(CGRect.zero) {
                    
                    newValue.frame = self.leftBarButtonContainerView.bounds
                }
                
                self.leftBarButtonContainerView.isHidden = false
                self.leftHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
                self.leftBarButtonItemWidth = newValue.frame.width

                newValue.translatesAutoresizingMaskIntoConstraints = false
                
                self.leftBarButtonContainerView.addSubview(newValue)
                self.leftBarButtonContainerView.jsq_pinAllEdgesOfSubview(newValue)
                self.setNeedsUpdateConstraints()
                return
            }
            
            self.leftHorizontalSpacingConstraint.constant = 0
            self.leftBarButtonItemWidth = 0
            self.leftBarButtonContainerView.isHidden = true
        }
    }
    var leftBarButtonItemWidth: CGFloat {
        
        get {
            
            return self.leftBarButtonContainerViewWidthConstraint.constant
        }
        
        set {
            
            self.leftBarButtonContainerViewWidthConstraint.constant = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    open dynamic var rightBarButtonItem: UIButton? {
        
        willSet {
            
            self.rightBarButtonItem?.removeFromSuperview()
            
            if let newValue = newValue {
                
                if newValue.frame.equalTo(CGRect.zero) {
                    
                    newValue.frame = self.rightBarButtonContainerView.bounds
                }
                
                self.rightBarButtonContainerView.isHidden = false
                self.rightHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
                self.rightBarButtonItemWidth = newValue.frame.width

                newValue.translatesAutoresizingMaskIntoConstraints = false
                
                self.rightBarButtonContainerView.addSubview(newValue)
                self.rightBarButtonContainerView.jsq_pinAllEdgesOfSubview(newValue)
                self.setNeedsUpdateConstraints()
                return
            }
            
            self.rightHorizontalSpacingConstraint.constant = 0
            self.rightBarButtonItemWidth = 0
            self.rightBarButtonContainerView.isHidden = true
        }
    }
    var rightBarButtonItemWidth: CGFloat {
        
        get {
            
            return self.rightBarButtonContainerViewWidthConstraint.constant
        }
        
        set {
            
            self.rightBarButtonContainerViewWidthConstraint.constant = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    open class func nib() -> UINib {
        
        return UINib(nibName: JSQMessagesToolbarContentView.jsq_className, bundle: Bundle(for: JSQMessagesToolbarContentView.self))
    }
    
    // MARK: - Initialization
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
        self.rightHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
        
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - UIView overrides
    
    open override func setNeedsDisplay() {
    
        super.setNeedsDisplay()

        self.textView?.setNeedsDisplay()
    }
}
