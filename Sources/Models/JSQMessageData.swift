//
//  JSQMessageData.swift
//  JSQMessagesViewController
//
//

import Foundation

@objc public protocol JSQMessageData {
    
    var senderId: String { get }
    var senderDisplayName: String { get }
    var date: Date { get }
    var isMediaMessage: Bool { get }
    var messageHash: Int { get }
    
    var text: String? { get }
    var media: JSQMessageMediaData? { get }
}
