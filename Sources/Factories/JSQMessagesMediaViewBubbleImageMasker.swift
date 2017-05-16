//
//  JSQMessagesMediaViewBubbleImageMasker.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

open class JSQMessagesMediaViewBubbleImageMasker {
    
    fileprivate(set) var bubbleImageFactory: JSQMessagesBubbleImageFactory
    
    public convenience init() {
        
        self.init(bubbleImageFactory: JSQMessagesBubbleImageFactory())
    }
    
    public init(bubbleImageFactory: JSQMessagesBubbleImageFactory) {
        
        self.bubbleImageFactory = bubbleImageFactory
    }
    
    // MARK: - View masking
    
    open func applyOutgoingBubbleImageMask(mediaView: UIView) {
        
        let bubbleImageData = self.bubbleImageFactory.outgoingMessagesBubbleImage(color: UIColor.white)
        self.jsq_maskView(mediaView, image: bubbleImageData.messageBubbleImage)
    }
    
    open func applyIncomingBubbleImageMask(mediaView: UIView) {
        
        let bubbleImageData = self.bubbleImageFactory.incomingMessagesBubbleImage(color: UIColor.white)
        self.jsq_maskView(mediaView, image: bubbleImageData.messageBubbleImage)
    }
    
    open class func applyBubbleImageMaskToMediaView(_ mediaView: UIView, isOutgoing: Bool) {
        
        let masker = JSQMessagesMediaViewBubbleImageMasker()
        
        if isOutgoing {
            masker.applyOutgoingBubbleImageMask(mediaView: mediaView)
        }
        else {
            masker.applyIncomingBubbleImageMask(mediaView: mediaView)
        }
    }
    
    // MARK: - Private
    
    fileprivate func jsq_maskView(_ view: UIView, image: UIImage) {
        
        let imageViewMask = UIImageView(image: image)
        imageViewMask.frame = view.frame.insetBy(dx: 2, dy: 2)
        
        view.layer.mask = imageViewMask.layer
    }
}
