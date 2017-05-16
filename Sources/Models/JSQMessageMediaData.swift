//
//  JSQMessageMediaData.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

@objc public protocol JSQMessageMediaData: NSObjectProtocol {
    
    var mediaView: UIView? { get }
    var mediaViewDisplaySize: CGSize { get }
    var mediaPlaceholderView: UIView { get }
    var mediaHash: Int { get }
}
