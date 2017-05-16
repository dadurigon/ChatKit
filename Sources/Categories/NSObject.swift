//
//  NSObject.swift
//  JSQMessagesSwift
//
//
//

import UIKit

extension NSObject {
    
    class var jsq_className: String {
        return String(describing: self)
    }
    
    var jsq_className: String {
        return type(of: self).jsq_className
    }
    
}
