//
//  JSQMessagesBubbleImageFactory.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

open class JSQMessagesBubbleImageFactory {
    
    fileprivate let bubbleImage: UIImage
    fileprivate var capInsets: UIEdgeInsets
    
    public convenience init() {
        
        //self.init(bubbleImage: UIImage.jsq_bubbleCompactImage()!, capInsets: UIEdgeInsets.zero)
        self.init(bubbleImage: UIImage.jsq_myCustomBubble()! , capInsets: UIEdgeInsets.zero)

    }
    
    public init(bubbleImage: UIImage, capInsets: UIEdgeInsets) {
    
        self.bubbleImage = bubbleImage
        self.capInsets = capInsets
        
        if UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsets.zero) {
            
            self.capInsets = self.jsq_centerPointEdgeInsetsForImageSize(bubbleImage.size)
        }
        else {
            
            self.capInsets = capInsets
        }
    }
    
    // MARK: - Public
    
    open func outgoingMessagesBubbleImage(color: UIColor) -> JSQMessagesBubbleImage {

        return self.jsq_messagesBubbleImage(color: color, flippedForIncoming: false)
    }
    
    open func incomingMessagesBubbleImage(color: UIColor) -> JSQMessagesBubbleImage {
        
        return self.jsq_messagesBubbleImage(color: color, flippedForIncoming: true)
    }
    
    // MARK: - Private
    
    func jsq_centerPointEdgeInsetsForImageSize(_ bubbleImageSize: CGSize) -> UIEdgeInsets {
        
        let center = CGPoint(x: bubbleImageSize.width/2, y: bubbleImageSize.height/2)
        return UIEdgeInsetsMake(center.y, center.x, center.y, center.x)
    }
    
    func jsq_messagesBubbleImage(color: UIColor, flippedForIncoming: Bool) -> JSQMessagesBubbleImage {
        
        var normalBubble = self.bubbleImage.jsq_imageMaskedWithColor(color)
        var highlightedBubble = self.bubbleImage.jsq_imageMaskedWithColor(color.jsq_colorByDarkeningColorWithValue(0.12))
        
        if flippedForIncoming {
            
            normalBubble = self.jsq_horizontallyFlippedImage(normalBubble)
            highlightedBubble = self.jsq_horizontallyFlippedImage(highlightedBubble)
        }
        
        normalBubble = self.jsq_stretchableImage(normalBubble, capInsets: self.capInsets)
        highlightedBubble = self.jsq_stretchableImage(highlightedBubble, capInsets: self.capInsets)
        
        return JSQMessagesBubbleImage(bubbleImage: normalBubble, highlightedImage: highlightedBubble)
    }
    
    func jsq_horizontallyFlippedImage(_ image: UIImage) -> UIImage {
        
        if let cgImage = image.cgImage {
            
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
        }
        
        return image
    }
    
    func jsq_stretchableImage(_ image: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}
