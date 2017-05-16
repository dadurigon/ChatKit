//
//  ActionButton.swift
//  JSQMessagesSwift
//
//
//

import UIKit

open class JSQAccessoryButton: UIButton {
    
    public var sourses: [(image: UIImage, title: String, action: () -> ())]!
    
     public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(JSQAccessoryButton.didTap(sender:)), for: .touchUpInside)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(JSQAccessoryButton.didTap(sender:)), for: .touchUpInside)
    }
    
    func didTap(sender: JSQAccessoryButton) {
        becomeFirstResponder()
    }
    
    func didTapDone(sender: UIButton) {
        resignFirstResponder()
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open var inputView: UIView? {
        let view = JSQActionSelectView(frame: CGRect(x: 0, y: 0, width: 500, height: 258))
        view.delegate = self
        view.sourse = self.sourses.map {
            return (image: $0.image, title: $0.title)
        }
        return view
    }
    
}

extension JSQAccessoryButton: UIKeyInput {
    public var hasText: Bool {
        return false
    }
    
    public func insertText(_ text: String) {
    }
    
    public func deleteBackward() {
    }
}

extension JSQAccessoryButton: JSQActionSelectViewDelegate {
    public func didSelectView(atIndex index: Int) {
        sourses[index].action()
    }
}
