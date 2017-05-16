//
//  JSQMessagesCollectionView.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesCollectionView: UICollectionView, JSQMessagesCollectionViewCellDelegate, JSQMessagesLoadEarlierHeaderViewDelegate {
    
    open var messagesDataSource: JSQMessagesCollectionViewDataSource? {
        get { return self.dataSource as? JSQMessagesCollectionViewDataSource }
    }
    open var messagesDelegate: JSQMessagesCollectionViewDelegateFlowLayout? {
        get { return self.delegate as? JSQMessagesCollectionViewDelegateFlowLayout }
    }
    open var messagesCollectionViewLayout: JSQMessagesCollectionViewFlowLayout {
        get { return self.collectionViewLayout as! JSQMessagesCollectionViewFlowLayout }
    }
    
    var typingIndicatorDisplaysOnLeft: Bool = true
    var typingIndicatorMessageBubbleColor: UIColor = UIColor.jsq_messageBubbleLightGrayColor()
    var typingIndicatorEllipsisColor: UIColor = UIColor.jsq_messageBubbleLightGrayColor().jsq_colorByDarkeningColorWithValue(0.3)
    
    var loadEarlierMessagesHeaderTextColor: UIColor = UIColor.jsq_messageBubbleBlueColor()
    
    // MARK: - Initialization
    
    func jsq_configureCollectionView() {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.keyboardDismissMode = .none
        self.alwaysBounceVertical = true
        self.bounces = true
        
        self.register(JSQMessagesCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier())
        
        self.register(JSQMessagesCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier())
        
        self.register(JSQMessagesCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellIncoming.mediaCellReuseIdentifier())
        
        self.register(JSQMessagesCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellOutgoing.mediaCellReuseIdentifier())
        
        self.register(JSQMessagesTypingIndicatorFooterView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: JSQMessagesTypingIndicatorFooterView.footerReuseIdentifier())
        
        self.register(JSQMessagesLoadEarlierHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JSQMessagesLoadEarlierHeaderView.headerReuseIdentifier())
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.jsq_configureCollectionView()
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.jsq_configureCollectionView()
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.jsq_configureCollectionView()
    }
    
    // MARK: - Typing indicator
    
    func dequeueTypingIndicatorFooterView(_ indexPath: IndexPath) -> JSQMessagesTypingIndicatorFooterView {
        
        let footerView = super.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: JSQMessagesTypingIndicatorFooterView.footerReuseIdentifier(), for: indexPath) as! JSQMessagesTypingIndicatorFooterView
                
        return footerView
    }
    
    // MARK: - Load earlier messages header
    
    func dequeueLoadEarlierMessagesViewHeader(_ indexPath: IndexPath) -> JSQMessagesLoadEarlierHeaderView {
        
        let headerView = super.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JSQMessagesLoadEarlierHeaderView.headerReuseIdentifier(), for: indexPath) as! JSQMessagesLoadEarlierHeaderView
        
        headerView.loadButton.tintColor = self.loadEarlierMessagesHeaderTextColor
        headerView.delegate = self
        
        return headerView
    }
    
    // MARK: - Load earlier messages header delegate
    
    open func headerView(_ headerView: JSQMessagesLoadEarlierHeaderView, didPressLoadButton sender: UIButton?) {
        
        self.messagesDelegate?.collectionView?(self, header: headerView, didTapLoadEarlierMessagesButton: sender)
    }
    
    // MARK: - Messages collection cell delegate

    open func messagesCollectionViewCellDidTapAvatar(_ cell: JSQMessagesCollectionViewCell) {
        
        if let indexPath = self.indexPath(for: cell) {
            
            self.messagesDelegate?.collectionView?(self, didTapAvatarImageView: cell.avatarImageView, atIndexPath: indexPath)
        }
    }
    
    open func messagesCollectionViewCellDidTapMessageBubble(_ cell: JSQMessagesCollectionViewCell) {
        
        if let indexPath = self.indexPath(for: cell) {
            
            self.messagesDelegate?.collectionView?(self, didTapMessageBubbleAt: indexPath)
        }
    }
    
    open func messagesCollectionViewCellDidTapCell(_ cell: JSQMessagesCollectionViewCell, atPosition position: CGPoint) {
        
        if let indexPath = self.indexPath(for: cell) {
            
            self.messagesDelegate?.collectionView?(self, didTapCellAt: indexPath, touchLocation: position)
        }
    }
    
    open func messagesCollectionViewCell(_ cell: JSQMessagesCollectionViewCell, didPerformAction action: Selector, withSender sender: AnyObject) {
        
        if let indexPath = self.indexPath(for: cell) {
            
            self.messagesDelegate?.collectionView?(self, performAction: action, forItemAt: indexPath, withSender: sender)
        }
    }
}
