//
//  UIImage.swift
//  JSQMessagesViewController
//
//

import UIKit

extension UIImage {
    
    public func jsq_imageMaskedWithColor(_ maskColor: UIColor) -> UIImage {
        
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -imageRect.height)
        
        context?.clip(to: imageRect, mask: self.cgImage!)
        context?.setFillColor(maskColor.cgColor)
        context?.fill(imageRect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {

            UIGraphicsEndImageContext()
            return image
        }

        UIGraphicsEndImageContext()
        return self
    }
    
    private class func jsq_bubbleImageFromBundle(name: String) -> UIImage? {
        
        if let bundle = Bundle.jsq_messagesAssetBundle(),
            let path = bundle.path(forResource: name, ofType: "png", inDirectory: "Images") {
        
            return UIImage(contentsOfFile: path)
        }
        
        return nil
    }
    
    public class func jsq_myCustomBubble() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_up")
    }

    
    public class func jsq_bubbleRegularImage() -> UIImage? {

        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_regular")
    }
    
    public class func jsq_bubbleRegularTaillessImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_tailless")
    }
    
    public class func jsq_bubbleRegularStrokedImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_stroked")
    }
    
    public class func jsq_bubbleRegularStrokedTaillessImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_stroked_tailless")
    }
    
    public class func jsq_bubbleCompactImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_min")
    }
    
    public class func jsq_bubbleCompactTaillessImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_min_tailless")
    }
    
    public class func jsq_defaultAccessoryImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "clip")
    }
    
    public class func jsq_defaultTypingIndicatorImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "typing")
    }
    
    public class func jsq_defaultPlayImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "play")
    }
    
    public class func jsq_PhotoLibrary() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "chat_bar_icons_pic")
    }
    public class func jsq_Camera() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "chat_bar_icons_camera")
    }
    public class func jsq_Location() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "chat_bar_icons_location")
    }

    
}
