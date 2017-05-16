//
//  JSQMessagesCollectionViewLayoutAttributes.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    open var messageBubbleFont: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    open var messageBubbleContainerViewWidth: CGFloat = 0
    open var textViewTextContainerInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var textViewFrameInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var incomingAvatarViewSize: CGSize = CGSize.zero
    open var outgoingAvatarViewSize: CGSize = CGSize.zero
    open var cellTopLabelHeight: CGFloat = 0
    open var messageBubbleTopLabelHeight: CGFloat = 0
    open var cellBottomLabelHeight: CGFloat = 0
    
    // MARK: - NSObject
    
    open override func isEqual(_ object: Any?) -> Bool {

        if let layoutAttributes = object as? JSQMessagesCollectionViewLayoutAttributes {

            if !layoutAttributes.messageBubbleFont.isEqual(self.messageBubbleFont)
                || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets, self.textViewFrameInsets)
                || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets, self.textViewTextContainerInsets)
                || !layoutAttributes.incomingAvatarViewSize.equalTo(self.incomingAvatarViewSize)
                || !layoutAttributes.outgoingAvatarViewSize.equalTo(self.outgoingAvatarViewSize)
                || layoutAttributes.messageBubbleContainerViewWidth != self.messageBubbleContainerViewWidth
                || layoutAttributes.cellTopLabelHeight != self.cellTopLabelHeight
                || layoutAttributes.messageBubbleTopLabelHeight != self.messageBubbleTopLabelHeight
                || layoutAttributes.cellBottomLabelHeight != self.cellBottomLabelHeight {

                return false
            }
        }

        return super.isEqual(object)
    }

    open override var hash:Int {
        
        get {
            
            return (self.indexPath as NSIndexPath).hash
        }
    }
    
    // MARK: - NSCopying
    
    open override func copy(with zone: NSZone?) -> Any {

        let copy = super.copy(with: zone) as! JSQMessagesCollectionViewLayoutAttributes
        
        copy.messageBubbleFont = self.messageBubbleFont
        copy.messageBubbleContainerViewWidth = self.messageBubbleContainerViewWidth
        copy.textViewFrameInsets = self.textViewFrameInsets
        copy.textViewTextContainerInsets = self.textViewTextContainerInsets
        copy.incomingAvatarViewSize = self.incomingAvatarViewSize
        copy.outgoingAvatarViewSize = self.outgoingAvatarViewSize
        copy.cellTopLabelHeight = self.cellTopLabelHeight
        copy.messageBubbleTopLabelHeight = self.messageBubbleTopLabelHeight
        copy.cellBottomLabelHeight = self.cellBottomLabelHeight
        return copy
    }
}
