//
//  JSQMessagesAvatarImageFactory.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

open class JSQMessagesAvatarImageFactory {
    
    // MARK: - Public
    
    open class func avatarImage(placholder: UIImage, diameter: CGFloat) -> JSQMessagesAvatarImage {
        
        let circlePlaceholderImage = JSQMessagesAvatarImageFactory.jsq_circularImage(placholder, diameter: diameter, highlightedColor: nil)
        return JSQMessagesAvatarImage.avatar(placeholder: circlePlaceholderImage)
    }
    
    open class func avatarImage(image: UIImage, diameter: CGFloat) -> JSQMessagesAvatarImage {
        
        let avatar = JSQMessagesAvatarImageFactory.circularAvatar(image: image, diameter: diameter)
        let highlightedAvatar = JSQMessagesAvatarImageFactory.circularAvatar(highlightedImage: image, diameter: diameter)
        
        return JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: highlightedAvatar, placeholderImage: avatar)
    }
    
    open class func circularAvatar(image: UIImage, diameter: CGFloat) -> UIImage {
        
        return JSQMessagesAvatarImageFactory.jsq_circularImage(image, diameter: diameter, highlightedColor: nil)
    }
    
    open class func circularAvatar(highlightedImage: UIImage, diameter: CGFloat) -> UIImage {
        
        return JSQMessagesAvatarImageFactory.jsq_circularImage(highlightedImage, diameter: diameter, highlightedColor: UIColor(white: 0.1, alpha: 0.3))
    }
    
    open class func avatarImage(userInitials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont, diameter: CGFloat) -> JSQMessagesAvatarImage {
        
        let avatar = JSQMessagesAvatarImageFactory.jsq_image(initials: userInitials, backgroundColor: backgroundColor, textColor: textColor, font: font, diameter: diameter)
        let highlightedAvatar = JSQMessagesAvatarImageFactory.jsq_circularImage(avatar, diameter: diameter, highlightedColor: UIColor(white: 0.1, alpha: 0.3))
        
        return JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: highlightedAvatar, placeholderImage: avatar)
    }
    
    // MARK: - Private
    
    fileprivate class func jsq_image(initials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont, diameter: CGFloat) -> UIImage {
        
        let frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        
        let attributes: [String: AnyObject] = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor
        ]
        
        let options: NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading]
        let textFrame = (initials as NSString).boundingRect(with: frame.size, options: options, attributes: attributes, context: nil)
        
        let frameMidPoint = CGPoint(x: frame.midX, y: frame.midY)
        let textFrameMidPoint = CGPoint(x: textFrame.midX, y: textFrame.midY)
        
        let dx = frameMidPoint.x - textFrameMidPoint.x
        let dy = frameMidPoint.y - textFrameMidPoint.y
        let drawPoint = CGPoint(x: dx, y: dy)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(frame)
        (initials as NSString).draw(at: drawPoint, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return JSQMessagesAvatarImageFactory.jsq_circularImage(image!, diameter: diameter, highlightedColor: nil)
    }
    
    fileprivate class func jsq_circularImage(_ image: UIImage, diameter: CGFloat, highlightedColor: UIColor?) -> UIImage {
        
        let frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        let imgPath = UIBezierPath(ovalIn: frame)
        imgPath.addClip()
        image.draw(in: frame)
        
        if let highlightedColor = highlightedColor {
            
            context?.setFillColor(highlightedColor.cgColor)
            context?.fillEllipse(in: frame)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
