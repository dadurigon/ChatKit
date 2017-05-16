//
//  JSQMessagesAvatarImage.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

open class JSQMessagesAvatarImage: NSObject, JSQMessageAvatarImageDataSource, NSCopying {
    
    open var avatarImage: UIImage?
    open var avatarHighlightedImage: UIImage?
    fileprivate(set) open var avatarPlaceholderImage: UIImage
    
    public required init(avatarImage: UIImage?, highlightedImage: UIImage?, placeholderImage: UIImage) {
        
        self.avatarImage = avatarImage
        self.avatarHighlightedImage = highlightedImage
        self.avatarPlaceholderImage = placeholderImage
        
        super.init()
    }
    
    open class func avatar(image: UIImage) -> JSQMessagesAvatarImage {
        
        return JSQMessagesAvatarImage(avatarImage: image, highlightedImage: image, placeholderImage: image)
    }
    
    open class func avatar(placeholder: UIImage) -> JSQMessagesAvatarImage {
        
        return JSQMessagesAvatarImage(avatarImage: nil, highlightedImage: nil, placeholderImage: placeholder)
    }
    
    // MARK: - NSObject
    
    open override var description: String {
        
        get {
            
            return "<\(type(of: self)): avatarImage=\(String(describing: self.avatarImage)), avatarHighlightedImage=\(String(describing: self.avatarHighlightedImage)), avatarPlaceholderImage=\(self.avatarPlaceholderImage)>"
        }
    }
    
    func debugQuickLookObject() -> AnyObject? {
        
        return UIImageView(image: self.avatarImage != nil ? self.avatarImage : self.avatarPlaceholderImage)
    }
    
    // MARK: - NSCopying
    
    open func copy(with zone: NSZone?) -> Any {
     
        return type(of: self).init(avatarImage: UIImage(cgImage: self.avatarImage!.cgImage!), highlightedImage: UIImage(cgImage: self.avatarHighlightedImage!.cgImage!), placeholderImage: UIImage(cgImage: self.avatarPlaceholderImage.cgImage!))
    }
}
