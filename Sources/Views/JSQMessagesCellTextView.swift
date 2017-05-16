//
//  JSQMessagesCellTextView.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesCellTextView: UITextView {
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.textColor = UIColor.white
        self.isEditable = false
        self.isSelectable = true
        self.isUserInteractionEnabled = true
        self.dataDetectorTypes = UIDataDetectorTypes()
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = false
        self.backgroundColor = UIColor.clear
        self.contentInset = UIEdgeInsets.zero
        self.scrollIndicatorInsets = UIEdgeInsets.zero
        self.contentOffset = CGPoint.zero
        self.textContainerInset = UIEdgeInsets.zero
        self.textContainer.lineFragmentPadding = 0
        self.linkTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
        ]
    }
    
    //  prevent selecting text
    open override var selectedRange: NSRange {
        
        didSet {
            
            if NSEqualRanges(self.selectedRange, oldValue) {

                return
            }
            
            self.selectedRange = NSMakeRange(NSNotFound, 0)
        }
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //  ignore double-tap to prevent copy/define/etc. menu from showing
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            
            if tap.numberOfTapsRequired == 2 {
                
                return false
            }
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        //  ignore double-tap to prevent copy/define/etc. menu from showing
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            
            if tap.numberOfTapsRequired == 2 {
                
                return false
            }
        }
        
        return true
    }
}
