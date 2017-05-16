//
//  Date+Ext.swift
//  JSQMessagesSwift
//
//
//

import UIKit

extension Date {

    func jsq_Mmdd() -> String {
        
        let string = DateHelper.shared.jsq_HHmmFormat .string(from: self)
        
        return string
    }
    
}
