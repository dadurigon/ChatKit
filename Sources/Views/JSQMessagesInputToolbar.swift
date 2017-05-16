//
//  JSQMessagesInputToolbar.swift
//  JSQMessagesViewController
//
//

import UIKit

let kJSQMessagesInputToolbarKeyValueObservingContext: UnsafeMutableRawPointer? = nil

public protocol JSQMessagesInputToolbarDelegate: UIToolbarDelegate {
    
    func messagesInputToolbar(_ toolbar: JSQMessagesInputToolbar, didPressRightBarButton sender: UIButton)
    func messagesInputToolbar(_ toolbar: JSQMessagesInputToolbar, didPressLeftBarButton sender: UIButton)
}

open class JSQMessagesInputToolbar: UIToolbar {
    
    var toolbarDelegate: JSQMessagesInputToolbarDelegate? {
        get { return self.delegate as? JSQMessagesInputToolbarDelegate }
        set { self.delegate = newValue }
    }
    
    fileprivate(set) open var contentView: JSQMessagesToolbarContentView!
    
    open var sendButtonOnRight: Bool = true
    open var preferredDefaultHeight: CGFloat = 44
    open var maximumHeight: Int = NSNotFound
    
    fileprivate var jsq_isObserving: Bool = false
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbarContentView = self.loadToolbarContentView()
        toolbarContentView.frame = self.frame
        self.addSubview(toolbarContentView)
        self.jsq_pinAllEdgesOfSubview(toolbarContentView)
        self.setNeedsUpdateConstraints()
        self.contentView = toolbarContentView
        
        self.jsq_addObservers()
        
        self.contentView.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.contentView.rightBarButtonItem = JSQMessagesToolbarButtonFactory.defaultSendButtonItem()
        
        self.toggleSendButtonEnabled()
    }

    func loadToolbarContentView() -> JSQMessagesToolbarContentView {
        
        return Bundle(for: JSQMessagesToolbarContentView.self).loadNibNamed(JSQMessagesToolbarContentView.jsq_className, owner: nil, options: nil)!.first as! JSQMessagesToolbarContentView
    }
    
    deinit {
        
        self.jsq_removeObservers()
        self.contentView = nil
    }
    
    // MARK: - Input toolbar
    
    func toggleSendButtonEnabled() {
        
        let hasText = self.contentView.textView.hasText
        
        if self.sendButtonOnRight {
            
            self.contentView.rightBarButtonItem?.isEnabled = hasText
        }
        else {
            
            self.contentView.leftBarButtonItem?.isEnabled = hasText
        }
    }
    
    // MARK: - Actions
    
    func jsq_leftBarButtonPressed(_ sender: UIButton) {
        
        self.toolbarDelegate?.messagesInputToolbar(self, didPressLeftBarButton: sender)
    }
    
    func jsq_rightBarButtonPressed(_ sender: UIButton) {
        
        self.toolbarDelegate?.messagesInputToolbar(self, didPressRightBarButton: sender)
    }
    
    // MARK: - Key-value observing
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == kJSQMessagesInputToolbarKeyValueObservingContext {
            
            if let object = object as? JSQMessagesToolbarContentView {
                
                if object == self.contentView {
                    
                    if keyPath == "leftBarButtonItem" {
                        
                        self.contentView.leftBarButtonItem?.removeTarget(self, action: nil, for: .touchUpInside)
                        self.contentView.leftBarButtonItem?.addTarget(self, action: #selector(JSQMessagesInputToolbar.jsq_leftBarButtonPressed(_:)), for: .touchUpInside)
                    }
                    else if keyPath == "rightBarButtonItem" {
                        
                        self.contentView.rightBarButtonItem?.removeTarget(self, action: nil, for: .touchUpInside)
                        self.contentView.rightBarButtonItem?.addTarget(self, action: #selector(JSQMessagesInputToolbar.jsq_rightBarButtonPressed(_:)), for: .touchUpInside)
                    }
                    
                    self.toggleSendButtonEnabled()
                }
            }
        }
    }
    
    func jsq_addObservers() {
        
        if self.jsq_isObserving {
            
            return
        }
        
        self.contentView.addObserver(self, forKeyPath: "leftBarButtonItem", options: NSKeyValueObservingOptions(), context: kJSQMessagesInputToolbarKeyValueObservingContext)
        self.contentView.addObserver(self, forKeyPath: "rightBarButtonItem", options: NSKeyValueObservingOptions(), context: kJSQMessagesInputToolbarKeyValueObservingContext)
        
        self.jsq_isObserving = true
    }
    
    func jsq_removeObservers() {
        
        if !self.jsq_isObserving {
            return
        }
        
        self.contentView.removeObserver(self, forKeyPath: "leftBarButtonItem", context: kJSQMessagesInputToolbarKeyValueObservingContext)
        self.contentView.removeObserver(self, forKeyPath: "rightBarButtonItem", context: kJSQMessagesInputToolbarKeyValueObservingContext)
        
        self.jsq_isObserving = false
    }
}
