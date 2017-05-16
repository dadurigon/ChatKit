//
//  JSQMessagesCollectionViewCellIncoming.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesCollectionViewCellIncoming: JSQMessagesCollectionViewCell {
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.messageBubbleTopLabel.textAlignment = .left
        self.cellBottomLabel.textAlignment = .left
    }
    
    open override class func nib() -> UINib {
        
        return UINib(nibName: JSQMessagesCollectionViewCellIncoming.jsq_className, bundle: Bundle(for: JSQMessagesCollectionViewCellIncoming.self))
    }
    
    open override class func cellReuseIdentifier() -> String {
        
        return JSQMessagesCollectionViewCellIncoming.jsq_className
    }
    
    open override class func mediaCellReuseIdentifier() -> String {
        
        return JSQMessagesCollectionViewCellIncoming.jsq_className + "_JSQMedia"
    }
}
