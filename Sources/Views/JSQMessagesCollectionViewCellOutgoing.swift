//
//  JSQMessagesCollectionViewCellOutgoing.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesCollectionViewCellOutgoing: JSQMessagesCollectionViewCell {
    
    @IBOutlet fileprivate(set) open var deliveryStatus: UILabel!

    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.messageBubbleTopLabel.textAlignment = .right
        self.cellBottomLabel.textAlignment = .right
    }
    
    open override class func nib() -> UINib {
        
        return UINib(nibName: JSQMessagesCollectionViewCellOutgoing.jsq_className, bundle: Bundle(for: JSQMessagesCollectionViewCellOutgoing.self))
    }
    
    open override class func cellReuseIdentifier() -> String {
        
        return JSQMessagesCollectionViewCellOutgoing.jsq_className
    }
    
    open override class func mediaCellReuseIdentifier() -> String {
        
        return JSQMessagesCollectionViewCellOutgoing.jsq_className + "_JSQMedia"
    }
}
