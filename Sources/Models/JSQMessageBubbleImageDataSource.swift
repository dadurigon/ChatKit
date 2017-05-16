//
//  JSQMessageBubbleImageDataSource.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

@objc public protocol JSQMessageBubbleImageDataSource {
    
    var messageBubbleImage: UIImage { get }
    var messageBubbleHighlightedImage: UIImage { get }
}
