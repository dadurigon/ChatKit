//
//  UIDevice.swift
//  JSQMessagesViewController
//
//

import UIKit

extension UIDevice {
    
    class func jsq_isCurrentDeviceBeforeiOS8() -> Bool {
        
        return UIDevice.current.systemVersion.compare("8.0", options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
}
