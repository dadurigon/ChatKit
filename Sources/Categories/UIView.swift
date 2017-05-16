//
//  UIView.swift
//  JSQMessagesViewController
//
//

import UIKit

extension UIView {

    public func jsq_pinSubview(_ subview: UIView, toEdge attribute: NSLayoutAttribute) {
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: subview, attribute: attribute, multiplier: 1, constant: 0))
    }
    
    public func jsq_pinAllEdgesOfSubview(_ subview: UIView) {
        
        self.jsq_pinSubview(subview, toEdge: .bottom)
        self.jsq_pinSubview(subview, toEdge: .top)
        self.jsq_pinSubview(subview, toEdge: .leading)
        self.jsq_pinSubview(subview, toEdge: .trailing)
    }
}

extension UIView {
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }
        set (color) {
            self.layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return 0
        }
        set (width) {
            self.layer.borderWidth = width
        }
    }
}
