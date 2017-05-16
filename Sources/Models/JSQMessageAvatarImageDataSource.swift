//
//  JSQMessageAvatarImageDataSource.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

@objc public protocol JSQMessageAvatarImageDataSource {
    
    var avatarImage: UIImage? { get }
    var avatarHighlightedImage: UIImage? { get }
    var avatarPlaceholderImage: UIImage { get }
}
