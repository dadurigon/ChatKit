//
//  JSQMessagesBubbleImage.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

open class JSQMessagesBubbleImage: NSObject, JSQMessageBubbleImageDataSource, NSCopying {
    
    fileprivate(set) open var messageBubbleImage: UIImage
    fileprivate(set) open var messageBubbleHighlightedImage: UIImage
    
    public required init(bubbleImage: UIImage, highlightedImage: UIImage) {
        
        self.messageBubbleImage = bubbleImage
        self.messageBubbleHighlightedImage = highlightedImage
    }
    
    // MARK: - NSCopying
    
    open func copy(with zone: NSZone?) -> Any {
        
        return type(of: self).init(bubbleImage: UIImage(cgImage: self.messageBubbleImage.cgImage!), highlightedImage: UIImage(cgImage: self.messageBubbleHighlightedImage.cgImage!))
    }
}
