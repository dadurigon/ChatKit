//
//  String.swift
//  JSQMessagesViewController
//
//

import Foundation

extension String {
    
    public func jsq_stringByTrimingWhitespace() -> String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
