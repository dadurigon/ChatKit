//
//  JSQMessagesKeyboardController.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

public let JSQMessagesKeyboardControllerNotificationKeyboardDidChangeFrame = "JSQMessagesKeyboardControllerNotificationKeyboardDidChangeFrame"
public let JSQMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame = "JSQMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame"

public protocol JSQMessagesKeyboardControllerDelegate {
    
    func keyboardController(_ keyboardController: JSQMessagesKeyboardController, keyboardDidChangeFrame keyboardFrame: CGRect)
}

open class JSQMessagesKeyboardController: NSObject, UIGestureRecognizerDelegate {
    
    open var delegate: JSQMessagesKeyboardControllerDelegate?
    open var actionButton: JSQAccessoryButton?

    fileprivate(set) open var textView: UITextView
    fileprivate(set) open var contextView: UIView
    fileprivate(set) open var panGestureRecognizer: UIPanGestureRecognizer
    
    open var keyboardTriggerPoint: CGPoint = CGPoint.zero
    open var keyboardIsVisible: Bool {
        
        get {
            
            return self.keyboardView != nil
        }
    }
    open var currentKeyboardFrame: CGRect {
        
        get {
            
            if !self.keyboardIsVisible {
                
                return CGRect.null
            }
            
            return self.keyboardView?.frame ?? CGRect.null
        }
    }
    
    fileprivate var jsq_isObserving: Bool = false
    fileprivate var keyboardView: UIView? {
        
        didSet {
            
            if self.keyboardView != nil {
                
                self.jsq_removeKeyboardFrameObserver()
            }
            
            if let keyboardView = self.keyboardView {
                
                if !self.jsq_isObserving {
                    
                    keyboardView.addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.old,NSKeyValueObservingOptions.new], context: self.kJSQMessagesKeyboardControllerKeyValueObservingContext)
                    
                    self.jsq_isObserving = true
                }
            }
        }
    }
    
    fileprivate let kJSQMessagesKeyboardControllerKeyValueObservingContext: UnsafeMutableRawPointer? = nil
    typealias JSQAnimationCompletionBlock = ((Bool) -> Void)
    
    // MARK: - Initialization
    
    public init(textView: UITextView, contextView: UIView, panGestureRecognizer: UIPanGestureRecognizer, delegate: JSQMessagesKeyboardControllerDelegate?) {
        
        self.textView = textView
        self.contextView = contextView
        self.panGestureRecognizer = panGestureRecognizer
        self.delegate = delegate
    }
    
    // MARK: - Keyboard controller
    
    open func beginListeningForKeyboard() {
        
        if self.textView.inputAccessoryView == nil {
            
            self.textView.inputAccessoryView = UIView()
        }
        
        self.jsq_registerForNotifications()
    }
    
    open func endListeningForKeyboard() {
        
        self.jsq_unregisterForNotifications()
        
        self.jsq_setKeyboardView(hidden: false)
        self.keyboardView = nil
    }
    
    // MARK: - Notifications
    
    func jsq_registerForNotifications() {
        
        self.jsq_unregisterForNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesKeyboardController.jsq_didReceiveKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesKeyboardController.jsq_didReceiveKeyboardWillChangeFrameNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesKeyboardController.jsq_didReceiveKeyboardDidChangeFrameNotification(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesKeyboardController.jsq_didReceiveKeyboardDidHideNotification(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func jsq_unregisterForNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func jsq_didReceiveKeyboardDidShowNotification(_ notification: Notification) {
        
        if let view = self.textView.inputAccessoryView?.superview {
            self.keyboardView = view

        } else {
            
            // TODO: keyboardView
            
        }
        
        self.jsq_setKeyboardView(hidden: false)
        
        self.jsq_handleKeyboardNotification(notification) { (finished) -> Void in
            
            self.panGestureRecognizer.addTarget(self, action: #selector(JSQMessagesKeyboardController.jsq_handlePanGestureRecognizer(_:)))
        }
    }
    
    func jsq_didReceiveKeyboardWillChangeFrameNotification(_ notification: Notification) {

        self.jsq_handleKeyboardNotification(notification, completion: nil)
    }
    
    func jsq_didReceiveKeyboardDidChangeFrameNotification(_ notification: Notification) {
        
        self.jsq_setKeyboardView(hidden: false)
        self.jsq_handleKeyboardNotification(notification, completion: nil)
    }
    
    func jsq_didReceiveKeyboardDidHideNotification(_ notification: Notification) {
        
        self.keyboardView = nil
        
        self.jsq_handleKeyboardNotification(notification) { (finished) -> Void in
            
            self.panGestureRecognizer.removeTarget(self, action: nil)
        }
    }
    
    func jsq_handleKeyboardNotification(_ notification: Notification, completion: JSQAnimationCompletionBlock?) {
        
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            if keyboardEndFrame.isNull {
                
                return
            }
            
            if let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int ,
                let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double{
            
                    let animationCurveOption = UIViewAnimationOptions(rawValue: UInt(animationCurve << 16))
                let keyboardEndFrameConverted = self.contextView.convert(keyboardEndFrame, from: nil)

                UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurveOption, animations: { () -> Void in
                    
                    self.jsq_notifyKeyboardFrameNotification(frame: keyboardEndFrameConverted)

                }, completion: { (finished) -> Void in
                    
                    completion?(finished)
                })
            }
        }
    }
    
    // MARK: - Utilities
    
    func jsq_setKeyboardView(hidden: Bool) {
        
        self.keyboardView?.isHidden = hidden
        self.keyboardView?.isUserInteractionEnabled = !hidden
    }
    
    func jsq_notifyKeyboardFrameNotification(frame: CGRect) {
        
        self.delegate?.keyboardController(self, keyboardDidChangeFrame: frame)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: JSQMessagesKeyboardControllerNotificationKeyboardDidChangeFrame), object: self, userInfo: [JSQMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame: NSValue(cgRect: frame)])
    }
    
    func jsq_resetKeyboardAndTextView() {
        
        self.jsq_setKeyboardView(hidden: true)
        self.jsq_removeKeyboardFrameObserver()
        self.textView.resignFirstResponder()
        self.actionButton?.resignFirstResponder()
        
    }
    
    // MARK: - Key-value observing

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == self.kJSQMessagesKeyboardControllerKeyValueObservingContext {
            
            if let object = object as? UIView {
                
                if object == self.keyboardView && keyPath == "frame" {
                    
                    if let oldKeyboardFrame = (change?[NSKeyValueChangeKey.oldKey] as AnyObject).cgRectValue,
                        let newKeyboardFrame = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgRectValue {
                    
                        if (newKeyboardFrame.isNull || newKeyboardFrame.equalTo(oldKeyboardFrame)) {
                            return;
                        }
                        
                        let keyboardEndFrameConverted = self.contextView.convert(newKeyboardFrame, from: self.keyboardView?.superview)
                            
                        self.jsq_notifyKeyboardFrameNotification(frame: keyboardEndFrameConverted)
                    }
                }
            }
        }
    }
    
    func jsq_removeKeyboardFrameObserver() {
        
        if !self.jsq_isObserving {
            
            return
        }
        
        self.keyboardView?.removeObserver(self, forKeyPath: "frame", context: self.kJSQMessagesKeyboardControllerKeyValueObservingContext)
        
        self.jsq_isObserving = false
    }
    
    // MARK: - Pan gesture recognizer
    
    func jsq_handlePanGestureRecognizer(_ pan: UIPanGestureRecognizer) {
        
        let touch = pan.location(in: self.contextView.window)
        let contextViewWindowHeight = self.contextView.window?.frame.height ?? 0
        
        let keyboardViewHeight = self.keyboardView?.frame.height ?? 0
        let dragThresholdY = contextViewWindowHeight - keyboardViewHeight - self.keyboardTriggerPoint.y
        var newKeyboardViewFrame = self.keyboardView?.frame ?? CGRect.zero
        
        let userIsDraggingNearThresholdForDismissing = touch.y > dragThresholdY
        self.keyboardView?.isUserInteractionEnabled = !userIsDraggingNearThresholdForDismissing
        
        switch pan.state {
            
            case .changed:
                
                newKeyboardViewFrame.origin.y = touch.y + self.keyboardTriggerPoint.y
                
                //  bound frame between bottom of view and height of keyboard
                newKeyboardViewFrame.origin.y = min(newKeyboardViewFrame.origin.y, contextViewWindowHeight)
                newKeyboardViewFrame.origin.y = max(newKeyboardViewFrame.origin.y, contextViewWindowHeight - keyboardViewHeight)
                
                if newKeyboardViewFrame.minY == (self.keyboardView?.frame ?? CGRect.zero).minY {
                    
                    return
                }
                
                UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
                    
                    self.keyboardView?.frame = newKeyboardViewFrame
                }, completion: nil)
            
            case .ended, .cancelled, .failed:
                
                let keyboardViewIsHidden: Bool = (self.keyboardView?.frame ?? CGRect.zero).minY >= contextViewWindowHeight
                if keyboardViewIsHidden {
                    
                    self.jsq_resetKeyboardAndTextView()
                }
                let velocity = pan.velocity(in: self.contextView)
                let userIsScrollingDown: Bool = velocity.y > 0
                let shouldHide: Bool = userIsScrollingDown && userIsDraggingNearThresholdForDismissing
                
                newKeyboardViewFrame.origin.y = shouldHide ? contextViewWindowHeight : (contextViewWindowHeight - keyboardViewHeight)
            
                let options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut]
                UIView.animate(withDuration: 0.25, delay: 0, options: options, animations: { () -> Void in
                    
                    self.keyboardView?.frame = newKeyboardViewFrame
                }, completion: { (finished) -> Void in
                    
                    self.keyboardView?.isUserInteractionEnabled = !shouldHide
                    
                    if shouldHide {

                        self.jsq_resetKeyboardAndTextView()
                    }
                })
            
            default:
                break
        }
    }
}
