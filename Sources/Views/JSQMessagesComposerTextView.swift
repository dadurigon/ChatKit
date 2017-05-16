//
//  JSQMessagesComposerTextView.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesComposerTextView: UITextView {
    
    open var placeHolder: String? {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    open var placeHolderTextColor: UIColor = UIColor.lightGray {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    func jsq_configureTextView() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let cornerRadius: CGFloat = 6
        
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = cornerRadius
        
        self.scrollIndicatorInsets = UIEdgeInsetsMake(cornerRadius, 0, cornerRadius, 0)
        
        self.textContainerInset = UIEdgeInsetsMake(4, 2, 4, 2)
        self.contentInset = UIEdgeInsetsMake(1, 0, 1, 0)
        
        self.isScrollEnabled = true
        self.scrollsToTop = false
        self.isUserInteractionEnabled = true
        
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor.black
        self.textAlignment = .natural
        
        self.contentMode = .redraw
        self.dataDetectorTypes = UIDataDetectorTypes()
        self.keyboardAppearance = .default
        self.keyboardType = .default
        self.returnKeyType = .default
        
        self.text = nil
        
        self.jsq_addTextViewNotificationObservers()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.jsq_configureTextView()
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.jsq_configureTextView()
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.jsq_configureTextView()
    }
    
    deinit {
        
        self.jsq_removeTextViewNotificationObservers()
        self.placeHolder = nil
    }
    
    // MARK: - Composer text view
    
    open override var hasText : Bool {
    
        return self.text.jsq_stringByTrimingWhitespace().lengthOfBytes(using: String.Encoding.utf8) > 0
    }
    
    // MARK: - UITextView overrides
    
    open override var text: String! {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    open override var font: UIFont! {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    open override var textColor: UIColor! {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        
        didSet {
    
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing
    
    open override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if self.text.lengthOfBytes(using: String.Encoding.utf8) == 0 && self.placeHolder != nil {
            
            self.placeHolderTextColor.set()
            
            if let placholder = self.placeHolder {
            
                (placholder as NSString).draw(in: rect.insetBy(dx: 7, dy: 5), withAttributes: self.jsq_placeholderTextAttributes())
            }
        }
    }
    
    // MARK: - Notifications
    
    func jsq_addTextViewNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesComposerTextView.jsq_didReceiveTextViewNotification(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesComposerTextView.jsq_didReceiveTextViewNotification(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesComposerTextView.jsq_didReceiveTextViewNotification(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    func jsq_removeTextViewNotificationObservers() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    func jsq_didReceiveTextViewNotification(_ notification: Notification) {
        
        self.setNeedsDisplay()
    }
    
    // MARK: - Utilities
    
    func jsq_placeholderTextAttributes() -> [String : AnyObject] {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        
        return [
            NSFontAttributeName : self.font,
            NSForegroundColorAttributeName : self.placeHolderTextColor,
            NSParagraphStyleAttributeName : paragraphStyle
        ]
    }
}
