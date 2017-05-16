//
//  JSQMessagesTimestampFormatter.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit


open class JSQMessagesTimestampFormatter: NSObject {

    fileprivate(set) open var dateFormatter: DateFormatter = DateFormatter()
    
    fileprivate(set) open var dateTextAttributes: [String : AnyObject]
    fileprivate(set) open var timeTextAttributes: [String : AnyObject]
    
    open static let sharedFormatter: JSQMessagesTimestampFormatter = JSQMessagesTimestampFormatter()
    
    override init() {
        
        self.dateFormatter.locale = Locale.current
        self.dateFormatter.doesRelativeDateFormatting = true
        
        let color = UIColor.lightGray
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .center
        
        self.dateTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        self.timeTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
    }
    
    // MARK: - Formatter    
    open func timestamp(_ date: Date) -> String {
        
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .short

        return self.dateFormatter.string(from: date)
    }
    
    open func attributedTimestamp(_ date: Date) -> NSAttributedString {
    
        let relativeDate = self.relativeDate(date)
        let time = self.time(date)
        
        let timestamp = NSMutableAttributedString(string: relativeDate, attributes: self.dateTextAttributes)
        timestamp.append(NSAttributedString(string: " "))
        timestamp.append(NSAttributedString(string: time, attributes: self.timeTextAttributes))
        
        return NSAttributedString(attributedString: timestamp)
    }
    
    open func time(_ date: Date) -> String {
        
        self.dateFormatter.dateStyle = .none
        self.dateFormatter.timeStyle = .short
        
        return self.dateFormatter.string(from: date)
    }
    
    open func relativeDate(_ date: Date) -> String {
        
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
        
        return self.dateFormatter.string(from: date)
    }
}
