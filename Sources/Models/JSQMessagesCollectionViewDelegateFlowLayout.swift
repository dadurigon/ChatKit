//
//  JSQMessagesCollectionViewDelegateFlowLayout.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

@objc public protocol JSQMessagesCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {

    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAt indexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, didTapAvatarImageView imageView: UIImageView, atIndexPath indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, didTapCellAt indexPath: IndexPath, touchLocation: CGPoint)
    @objc optional func collectionView(_ collectionView: JSQMessagesCollectionView, header: JSQMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton button: UIButton?)
}
