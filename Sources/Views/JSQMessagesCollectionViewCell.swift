//
//  JSQMessagesCollectionViewCell.swift
//  JSQMessagesViewController
//
//

import UIKit

public protocol JSQMessagesCollectionViewCellDelegate {
    
    func messagesCollectionViewCellDidTapAvatar(_ cell: JSQMessagesCollectionViewCell)
    func messagesCollectionViewCellDidTapMessageBubble(_ cell: JSQMessagesCollectionViewCell)
    
    func messagesCollectionViewCellDidTapCell(_ cell: JSQMessagesCollectionViewCell, atPosition position: CGPoint)
    func messagesCollectionViewCell(_ cell: JSQMessagesCollectionViewCell, didPerformAction action: Selector, withSender sender: AnyObject)
}

open class JSQMessagesCollectionViewCell: UICollectionViewCell {
    
    fileprivate static var jsqMessagesCollectionViewCellActions: Set<Selector> = Set()
    
    open var delegate: JSQMessagesCollectionViewCellDelegate?
    open var bubbleImage: UIImage?
    
    @IBOutlet fileprivate(set) open var sendTimeLabel: UILabel!
    @IBOutlet fileprivate(set) open var cellTopLabel: JSQMessagesLabel!
    @IBOutlet fileprivate(set) open var messageBubbleTopLabel: JSQMessagesLabel!
    @IBOutlet fileprivate(set) open var cellBottomLabel: JSQMessagesLabel!
    
    @IBOutlet fileprivate(set) open var messageBubbleContainerView: UIView!
    @IBOutlet fileprivate(set) open var messageBubbleImageView: UIImageView?
    @IBOutlet fileprivate(set) open var textView: JSQMessagesCellTextView?
    
    @IBOutlet fileprivate(set) open var avatarImageView: UIImageView!
    @IBOutlet fileprivate(set) open var avatarContainerView: UIView!
    
    @IBOutlet fileprivate var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var avatarContainerViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate(set) var tapGestureRecognizer: UITapGestureRecognizer?
    
    fileprivate var textViewFrameInsets: UIEdgeInsets {
        
        set {

            if UIEdgeInsetsEqualToEdgeInsets(newValue, self.textViewFrameInsets) {
                
                return
            }
            
            self.jsq_update(constraint: self.textViewTopVerticalSpaceConstraint, withConstant: newValue.top)
            self.jsq_update(constraint: self.textViewBottomVerticalSpaceConstraint, withConstant: newValue.bottom)
            self.jsq_update(constraint: self.textViewAvatarHorizontalSpaceConstraint, withConstant: newValue.right)
            self.jsq_update(constraint: self.textViewMarginHorizontalSpaceConstraint, withConstant: newValue.left)
        }

        get {
            
            return UIEdgeInsetsMake(self.textViewTopVerticalSpaceConstraint.constant,
                                    self.textViewMarginHorizontalSpaceConstraint.constant,
                                    self.textViewBottomVerticalSpaceConstraint.constant,
                                    self.textViewAvatarHorizontalSpaceConstraint.constant)
        }
    }
    
    fileprivate var avatarViewSize: CGSize {
        
        set {
            
            if newValue.equalTo(self.avatarViewSize) {
                
                return
            }
            
            self.jsq_update(constraint: self.avatarContainerViewWidthConstraint, withConstant: newValue.width)
            self.jsq_update(constraint: self.avatarContainerViewHeightConstraint, withConstant: newValue.height)
        }
        
        get {
            
            return CGSize(width: self.avatarContainerViewWidthConstraint.constant,
                              height: self.avatarContainerViewHeightConstraint.constant)
        }
    }
    
    open var mediaView: UIView? {
        
        didSet {
            
            if let mediaView = self.mediaView {
                
                self.messageBubbleImageView?.removeFromSuperview()
                self.textView?.removeFromSuperview()

                mediaView.translatesAutoresizingMaskIntoConstraints = false
                mediaView.frame = self.messageBubbleContainerView.bounds
                
                self.messageBubbleContainerView.addSubview(mediaView)
                self.messageBubbleContainerView.jsq_pinAllEdgesOfSubview(mediaView)
                
            }
        }
    }
    
    open override var backgroundColor: UIColor? {
        
        didSet {
            
            self.cellTopLabel.backgroundColor = backgroundColor
            self.messageBubbleTopLabel.backgroundColor = backgroundColor
            self.cellBottomLabel.backgroundColor = backgroundColor
            
            self.messageBubbleImageView?.backgroundColor = backgroundColor
            self.avatarImageView.backgroundColor = backgroundColor
            
            self.messageBubbleContainerView.backgroundColor = backgroundColor
            self.avatarContainerView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Class methods
    
    open class func nib() -> UINib {
        
        return UINib(nibName: JSQMessagesCollectionViewCell.jsq_className, bundle: Bundle(for: JSQMessagesCollectionViewCell.self))
    }
    
    open class func cellReuseIdentifier() -> String {
        
        return JSQMessagesCollectionViewCell.jsq_className
    }
    
    open class func mediaCellReuseIdentifier() -> String {
        
        return JSQMessagesCollectionViewCell.jsq_className + "_JSQMedia"
    }
    
    open class func registerMenuAction(_ action: Selector) {
        
        JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.insert(action)
    }
    
    // MARK: - Initialization
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.white
        
        self.cellTopLabelHeightConstraint.constant = 0
        self.messageBubbleTopLabelHeightConstraint.constant = 0
        self.cellBottomLabelHeightConstraint.constant = 0
        
        self.cellTopLabel.textAlignment = .center
        self.cellTopLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.cellTopLabel.textColor = UIColor.lightGray
        
        self.messageBubbleTopLabel.font = UIFont.systemFont(ofSize: 12)
        self.messageBubbleTopLabel.textColor = UIColor.lightGray
        
        self.cellBottomLabel.font = UIFont.systemFont(ofSize: 11);
        self.cellBottomLabel.textColor = UIColor.lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(JSQMessagesCollectionViewCell.jsq_handleTapGesture(_:)))
        self.addGestureRecognizer(tap)
        self.tapGestureRecognizer = tap
    }
    
    deinit {
        
        self.tapGestureRecognizer?.removeTarget(nil, action: nil)
        self.tapGestureRecognizer = nil
    }
    
    // MARK: - Collection view cell
    
    open override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.cellTopLabel.text = nil
        self.messageBubbleTopLabel.text = nil
        self.cellBottomLabel.text = nil
        
        self.textView?.dataDetectorTypes = UIDataDetectorTypes()
        self.textView?.text = nil
        self.textView?.attributedText = nil
        
        self.avatarImageView.image = nil
        self.avatarImageView.highlightedImage = nil
    }
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        return layoutAttributes
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        if let customAttributes = layoutAttributes as? JSQMessagesCollectionViewLayoutAttributes {
            
            if let textView = self.textView {
                
                if textView.font != customAttributes.messageBubbleFont {
                    
                    textView.font = customAttributes.messageBubbleFont
                }
                
                if !UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, customAttributes.textViewTextContainerInsets) {
                    
                    textView.textContainerInset = customAttributes.textViewTextContainerInsets
                }
            }
            
            self.textViewFrameInsets = customAttributes.textViewFrameInsets
            
            self.jsq_update(constraint: self.messageBubbleContainerWidthConstraint, withConstant: customAttributes.messageBubbleContainerViewWidth)
            self.jsq_update(constraint: self.cellTopLabelHeightConstraint, withConstant: customAttributes.cellTopLabelHeight)
            self.jsq_update(constraint: self.messageBubbleTopLabelHeightConstraint, withConstant: customAttributes.messageBubbleTopLabelHeight)
            self.jsq_update(constraint: self.cellBottomLabelHeightConstraint, withConstant: customAttributes.cellBottomLabelHeight)
            
            if self is JSQMessagesCollectionViewCellIncoming {
                
                self.avatarViewSize = customAttributes.incomingAvatarViewSize
            }
            else if self is JSQMessagesCollectionViewCellOutgoing {
                
                self.avatarViewSize = customAttributes.outgoingAvatarViewSize
            }
        }
    }
    
    open override var isHighlighted: Bool {
        
        didSet {
            
            self.messageBubbleImageView?.isHighlighted = self.isHighlighted
        }
    }
    
    open override var isSelected: Bool {
        
        didSet {
            
            self.messageBubbleImageView?.isHighlighted = self.isSelected
        }
    }
    
    open override var bounds: CGRect {
        
        didSet {
            
            if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
 
                self.contentView.frame = bounds
            }
        }
    }
    
    // MARK: - Menu actions
    
    open override func responds(to aSelector: Selector) -> Bool {
        
        if JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.contains(aSelector) {
            
            return true
        }
        
        return super.responds(to: aSelector)
    }
    
    //TODO: Swift compatibility
    /*override func forwardInvocation(anInvocation: NSInvocation!) {
        
        if JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.contains(aSelector) {
            
            return
        }
    }
    
    override func methodSignatureForSelector(aSelector: Selector) -> NSMethodSignature! {
        
        if JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.contains(aSelector) {
            
            return NSMethodSign
        }
    }*/
    
    // MARK: - Utilities
    
    func jsq_update(constraint: NSLayoutConstraint, withConstant constant: CGFloat) {
        
        if constraint.constant == constant {
            return
        }
        
        constraint.constant = constant
    }
    
    // MARK: - Gesture recognizers
    
    func jsq_handleTapGesture(_ tap: UITapGestureRecognizer) {
        
        let touchPoint = tap.location(in: self)
        
        if self.avatarContainerView.frame.contains(touchPoint) {
            
            self.delegate?.messagesCollectionViewCellDidTapAvatar(self)
        }
        else if self.messageBubbleContainerView.frame.contains(touchPoint) {
            
            self.delegate?.messagesCollectionViewCellDidTapMessageBubble(self)
        }
        else {
            
            self.delegate?.messagesCollectionViewCellDidTapCell(self, atPosition: touchPoint)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let touchPoint = touch.location(in: self)
        
        if let _ = gestureRecognizer as? UILongPressGestureRecognizer {
            
            return self.messageBubbleContainerView.frame.contains(touchPoint)
        }
        
        return true
    }
}
