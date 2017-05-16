//
//  UIColor.swift
//  JSQMessagesViewController
//
//

import UIKit

extension UIColor {
    
    public class func jsq_messageBubbleGreenColor() -> UIColor {
        
        return UIColor(hue: 130/360, saturation:0.68, brightness:0.84, alpha:1)
    }
    
    public class func jsq_messageBubbleBlueColor() -> UIColor {
        
        return UIColor(hue: 210/360, saturation:0.94, brightness:1, alpha:1)
    }
    
    public class func jsq_messageBubbleRedColor() -> UIColor {
        
        return UIColor(hue: 0, saturation:0.79, brightness:1, alpha:1)
    }
    
    public class func jsq_messageBubbleLightGrayColor() -> UIColor {
        
        return UIColor(hue: 240.0/360.0, saturation:0.02, brightness:0.94, alpha:1)
    }
    
    // MARK: - Utilities
    
    public func jsq_colorByDarkeningColorWithValue(_ value: CGFloat) -> UIColor {
        
        let totalComponents = self.cgColor.numberOfComponents
        let isGreyscale = (totalComponents == 2) ? true : false
        
        let oldComponents = self.cgColor.components
        var newComponents: [CGFloat] = []
        
        if isGreyscale {

            newComponents.append((oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value)
            newComponents.append((oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value)
            newComponents.append((oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value)
            newComponents.append((oldComponents?[1])!)
        }
        else {

            newComponents.append((oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value)
            newComponents.append((oldComponents?[1])! - value < 0.0 ? 0.0 : (oldComponents?[1])! - value)
            newComponents.append((oldComponents?[2])! - value < 0.0 ? 0.0 : (oldComponents?[2])! - value)
            newComponents.append((oldComponents?[3])!)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColor(colorSpace: colorSpace, components: newComponents)
        if let newColor = newColor {
            return UIColor(cgColor: newColor)
        }

        return self
    }
}
