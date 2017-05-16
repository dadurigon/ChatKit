//
//  JSQMessagesCollectionViewDataSource.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

@objc public protocol JSQMessagesCollectionViewDataSource: UICollectionViewDataSource {
    
    var senderId: String { get }
    var senderDisplayName: String { get }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData
    func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource
    func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource?
    
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString?
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString?
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAt indexPath: IndexPath) -> NSAttributedString?
}
