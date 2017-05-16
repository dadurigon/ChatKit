//
//  JSQMessagesCollectionViewFlowLayout.swift
//  JSQMessagesViewController
//
//

import UIKit

public let kJSQMessagesCollectionViewCellLabelHeightDefault: CGFloat = 20
public let kJSQMessagesCollectionViewAvatarSizeDefault: CGFloat = 30

open class JSQMessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    open override class var layoutAttributesClass : AnyClass {
        
        return JSQMessagesCollectionViewLayoutAttributes.self
    }
    
    open override class var invalidationContextClass : AnyClass {
        
        return JSQMessagesCollectionViewFlowLayoutInvalidationContext.self
    }
    
    open var messagesCollectionView: JSQMessagesCollectionView {
        
        get {
            
            return self.collectionView as! JSQMessagesCollectionView
        }
    }
    
    open var springinessEnabled: Bool = false {
        
        didSet {
            
            if !self.springinessEnabled {
                
                self.dynamicAnimator.removeAllBehaviors()
                self.visibleIndexPaths.removeAll()
            }
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    open var springResistanceFactor: CGFloat = 1000
    
    open var itemWidth: CGFloat {
        
        get {

            return (self.collectionView?.frame.width ?? 0) - self.sectionInset.left - self.sectionInset.right
        }
    }
    
    open var messageBubbleFont: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body) {
        
        didSet {
            
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    open var messageBubbleLeftRightMargin: CGFloat = 50 {
        
        didSet {
            
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    open var messageBubbleTextViewFrameInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6) {
        
        didSet {
            
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    open var messageBubbleTextViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsMake(7, 14, 7, 14) {
        
        didSet {
            
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    
    open var incomingAvatarViewSize: CGSize = CGSize(width: 30, height: 30) {
        
        didSet {
            
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    open var outgoingAvatarViewSize: CGSize = CGSize(width: 30, height: 30) {
        
        didSet {
            
            self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    
    open var cacheLimit: Int {
        
        get {
            
            return self.messageBubbleCache.countLimit
        }
    }
    
//    fileprivate var messageBubbleCache: NSCache = NSCache()
//    fileprivate var messageBubbleCache = NSCache<NSString, UIImage>()
    fileprivate var messageBubbleCache = NSCache<AnyObject, AnyObject>()


    fileprivate var dynamicAnimator: UIDynamicAnimator!
    fileprivate var visibleIndexPaths: Set<IndexPath> = Set<IndexPath>()
    fileprivate var latestDelta: CGFloat = 0
    fileprivate var bubbleImageAssetWidth: CGFloat = 0
    
    func jsq_configureFlowLayout() {
        
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsetsMake(10, 4, 10, 4)
        self.minimumLineSpacing = 4
        
        self.bubbleImageAssetWidth = UIImage.jsq_bubbleCompactImage()?.size.width ?? 0
        
        self.messageBubbleCache.name = "JSQMessagesCollectionViewFlowLayout.messageBubbleCache"
        self.messageBubbleCache.countLimit = 200
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            self.messageBubbleLeftRightMargin = 240
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesCollectionViewFlowLayout.jsq_didReceiveApplicationMemoryWarningNotification(_:)), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesCollectionViewFlowLayout.jsq_didReceiveDeviceOrientationDidChangeNotification(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        
        self.messageBubbleCache.removeAllObjects()
        self.dynamicAnimator.removeAllBehaviors()
        self.visibleIndexPaths.removeAll()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    public override init() {
        
        super.init()
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        
        self.jsq_configureFlowLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

        self.jsq_configureFlowLayout()
    }
    
    // MARK: - Notifications
    
    func jsq_didReceiveApplicationMemoryWarningNotification(_ notification: Notification) {
        
        self.jsq_resetLayout()
    }
    
    func jsq_didReceiveDeviceOrientationDidChangeNotification(_ notification: Notification) {
        
        self.jsq_resetLayout()
        self.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
    }
    
    // MARK: - Collection view flow layout
    
    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        
        if let context = context as? JSQMessagesCollectionViewFlowLayoutInvalidationContext {
            
            if context.invalidateDataSourceCounts {
                
                context.invalidateFlowLayoutAttributes = true
                context.invalidateFlowLayoutDelegateMetrics = true
            }
            
            if context.invalidateFlowLayoutAttributes || context.invalidateFlowLayoutDelegateMetrics {
                
                self.jsq_resetDynamicAnimator()
            }
            
            if context.invalidateFlowLayoutMessagesCache {
                
                self.jsq_resetLayout()
            }
        }
        
        super.invalidateLayout(with: context)
    }
    
    open override func prepare() {
        
        super.prepare()
        
        if self.springinessEnabled {
            
            let padding: CGFloat = -100
            let visibleRect = (self.collectionView?.bounds ?? CGRect.zero).insetBy(dx: padding, dy: padding)
            
            if let visibleItems = super.layoutAttributesForElements(in: visibleRect) {
            
                let visibleItemsIndexPaths = visibleItems.map { $0.indexPath } as [IndexPath]

                self.jsq_removeNoLongerVisibleBehaviors(Set<IndexPath>(visibleItemsIndexPaths))
                self.jsq_addNewlyVisibleBehaviors(visibleItems)
            }
        }
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if let attributesInRect = super.layoutAttributesForElements(in: rect) as? [JSQMessagesCollectionViewLayoutAttributes] {
        
            if self.springinessEnabled {
                
                var attributesInRectCopy = Set(attributesInRect)
                let dynamicAttributes = self.dynamicAnimator.items(in: rect)
                
                //  avoid duplicate attributes
                //  use dynamic animator attribute item instead of regular item, if it exists
                for eachItem in attributesInRect {
                    
                    for eachDynamicItem in dynamicAttributes {
                        
                        if let eachDynamicItem = eachDynamicItem as? JSQMessagesCollectionViewLayoutAttributes {
                            
                            if eachItem.indexPath == eachDynamicItem.indexPath && eachItem.representedElementCategory == eachDynamicItem.representedElementCategory {
                                
                                attributesInRectCopy.remove(eachItem)
                                attributesInRectCopy.insert(eachDynamicItem)
                            }
                        }
                    }
                }
            }

            for attributesItem in attributesInRect {
                
                if attributesItem.representedElementCategory == .cell {
                    
                    self.jsq_configureMessageCell(attributesItem)
                }
                else {
                    
                    attributesItem.zIndex = -1
                }
            }
        
            return attributesInRect
        }
        return []
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let customAttributes = super.layoutAttributesForItem(at: indexPath) as! JSQMessagesCollectionViewLayoutAttributes
        
        if customAttributes.representedElementCategory == .cell {
            
            self.jsq_configureMessageCell(customAttributes)
        }
        
        return customAttributes
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

        if self.springinessEnabled {
            
            let delta = newBounds.origin.y - self.messagesCollectionView.bounds.origin.y
            
            self.latestDelta = delta
            
            let touchLocation = self.messagesCollectionView.panGestureRecognizer.location(in: self.messagesCollectionView)
            
            for springBehaviour in self.dynamicAnimator.behaviors as? [UIAttachmentBehavior] ?? [] {
                
                self.jsq_adjust(springBehaviour, forTouchLocation: touchLocation)
                
                if let item = springBehaviour.items.first {
                    
                    self.dynamicAnimator.updateItem(usingCurrentState: item)
                }
            }
        }
        
        let oldBounds = self.messagesCollectionView.bounds
        if newBounds.width != oldBounds.width {

            return true
        }
        
        return false
    }

    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for updateItem in updateItems {
            
            if let indexPathAfterUpdate = updateItem.indexPathAfterUpdate {

                if self.springinessEnabled && self.dynamicAnimator.layoutAttributesForCell(at: indexPathAfterUpdate) != nil {

                    return
                }

                let collectionViewHeight = self.messagesCollectionView.bounds.height
                let attributes = JSQMessagesCollectionViewLayoutAttributes(forCellWith: indexPathAfterUpdate)

                if attributes.representedElementCategory == .cell {

                    self.jsq_configureMessageCell(attributes)
                }

                attributes.frame = CGRect(x: 0, y: collectionViewHeight, width: attributes.frame.width, height: attributes.frame.height)

                if self.springinessEnabled {

                    if let springBehaviour = self.jsq_springBehavior(layoutAttributesItem: attributes) {

                        self.dynamicAnimator.addBehavior(springBehaviour)
                    }
                }
            }
        }

    }

    // MARK: - Invalidation utilities

    func jsq_resetLayout() {
        
        self.messageBubbleCache.removeAllObjects()
        self.jsq_resetDynamicAnimator()
    }
    
    func jsq_resetDynamicAnimator () {
        
        if self.springinessEnabled {
            
            self.dynamicAnimator.removeAllBehaviors()
            self.visibleIndexPaths.removeAll()
        }
    }
    
    // MARK: - Message cell layout utilities
    
    func messageBubbleSize(_ indexPath: IndexPath) -> CGSize {
        
        if let messageItem = self.messagesCollectionView.messagesDataSource?.collectionView(self.messagesCollectionView, messageDataForItemAt: indexPath) {
        
            if let cachedSize = self.messageBubbleCache.object(forKey: String(messageItem.messageHash) as NSString) as? NSValue {
                
                return cachedSize.cgSizeValue
            }
            
            var finalSize = CGSize.zero
            
            if messageItem.isMediaMessage {
                
                finalSize = messageItem.media?.mediaViewDisplaySize ?? CGSize.zero
            }
            else {
                
                let avatarSize = self.jsq_avatarSize(indexPath)
                let spacingBetweenAvatarAndBubble: CGFloat = 2
                let horizontalContainerInsets = self.messageBubbleTextViewTextContainerInsets.left + self.messageBubbleTextViewTextContainerInsets.right
                let horizontalFrameInsets = self.messageBubbleTextViewFrameInsets.left + self.messageBubbleTextViewFrameInsets.right
                
                let horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets + spacingBetweenAvatarAndBubble
                let maximumTextWidth = self.itemWidth - avatarSize.width - self.messageBubbleLeftRightMargin - horizontalInsetsTotal
                
                let stringRect = (messageItem.text! as NSString).boundingRect(with: CGSize(width: maximumTextWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : self.messageBubbleFont], context: nil)
                
                let stringSize = stringRect.integral.size
                
                let verticalContainerInsets = self.messageBubbleTextViewTextContainerInsets.top + self.messageBubbleTextViewTextContainerInsets.bottom
                let verticalFrameInsets = self.messageBubbleTextViewFrameInsets.top + self.messageBubbleTextViewFrameInsets.bottom
                
                //  add extra 2 points of space, because `boundingRectWithSize:` is slightly off
                //  not sure why. magix. (shrug) if you know, submit a PR
                let verticalInsets = verticalContainerInsets + verticalFrameInsets + 2
                
                //  same as above, an extra 2 points of magix
                let finalWidth = max(stringSize.width + horizontalInsetsTotal, self.bubbleImageAssetWidth) + 2
                
                finalSize = CGSize(width: finalWidth, height: stringSize.height + verticalInsets)
            }
            
            self.messageBubbleCache.setObject(NSValue(cgSize: finalSize), forKey: messageItem.messageHash as AnyObject)
            
            return finalSize
        }
        
        return CGSize.zero
    }
    
    func sizeForItem(_ indexPath: IndexPath) -> CGSize {
        
        let messageBubbleSize = self.messageBubbleSize(indexPath)
        if let attributes = self.layoutAttributesForItem(at: indexPath) as? JSQMessagesCollectionViewLayoutAttributes {
            
            var finalHeight = messageBubbleSize.height
            finalHeight += attributes.cellTopLabelHeight
            finalHeight += attributes.messageBubbleTopLabelHeight
            finalHeight += attributes.cellBottomLabelHeight
            
            return CGSize(width: self.itemWidth, height: ceil(finalHeight))
        }
        return CGSize.zero
    }
    
    func jsq_configureMessageCell(_ layoutAttributes: JSQMessagesCollectionViewLayoutAttributes) {
        
        let indexPath = layoutAttributes.indexPath
        let messageBubbleSize = self.messageBubbleSize(indexPath)
        
        layoutAttributes.messageBubbleContainerViewWidth = messageBubbleSize.width
        layoutAttributes.textViewFrameInsets = self.messageBubbleTextViewFrameInsets
        layoutAttributes.textViewTextContainerInsets = self.messageBubbleTextViewTextContainerInsets
        layoutAttributes.messageBubbleFont = self.messageBubbleFont
        layoutAttributes.incomingAvatarViewSize = self.incomingAvatarViewSize
        layoutAttributes.outgoingAvatarViewSize = self.outgoingAvatarViewSize
        layoutAttributes.cellTopLabelHeight = self.messagesCollectionView.messagesDelegate?.collectionView?(self.messagesCollectionView, layout: self, heightForCellTopLabelAt: indexPath) ?? layoutAttributes.cellTopLabelHeight
        layoutAttributes.messageBubbleTopLabelHeight = self.messagesCollectionView.messagesDelegate?.collectionView?(self.messagesCollectionView, layout: self, heightForMessageBubbleTopLabelAt: indexPath) ?? layoutAttributes.messageBubbleTopLabelHeight
        layoutAttributes.cellBottomLabelHeight = self.messagesCollectionView.messagesDelegate?.collectionView?(self.messagesCollectionView, layout: self, heightForCellBottomLabelAt: indexPath) ?? layoutAttributes.cellBottomLabelHeight
        
    }
    
    func jsq_avatarSize(_ indexPath: IndexPath) -> CGSize {
        
        if let messageItem = self.messagesCollectionView.messagesDataSource?.collectionView(self.messagesCollectionView, messageDataForItemAt: indexPath) {
            
            let messageSender = messageItem.senderId
            if messageSender == self.messagesCollectionView.messagesDataSource?.senderId {
                
                return self.outgoingAvatarViewSize
            }
        }
        
        return self.incomingAvatarViewSize
    }
    
    // MARK: - Spring behavior utilities
    
    func jsq_springBehavior(layoutAttributesItem item: UICollectionViewLayoutAttributes) -> UIAttachmentBehavior? {
        
        if item.frame.size.equalTo(CGSize.zero) {
            
            return nil
        }
        
        let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
        springBehavior.length = 1
        springBehavior.damping = 1
        springBehavior.frequency = 1
        
        return springBehavior
    }
    
    func jsq_addNewlyVisibleBehaviors(_ visibleItems: [UICollectionViewLayoutAttributes]) {
        
        let newlyVisibleItems = visibleItems.filter { !self.visibleIndexPaths.contains($0.indexPath) }
        
        for item in newlyVisibleItems {
            
            if let springBehavior = self.jsq_springBehavior(layoutAttributesItem: item) {

                self.dynamicAnimator.addBehavior(springBehavior)
                self.visibleIndexPaths.insert(item.indexPath)
            }
        }
    }
    
    func jsq_removeNoLongerVisibleBehaviors(_ visibleItemsIndexPath: Set<IndexPath>) {
        
        if let behaviors = self.dynamicAnimator.behaviors as? [UIAttachmentBehavior] {
        
            let behaviorsToRemove = behaviors.filter {
                if let layoutAttributes = $0.items.first as? UICollectionViewLayoutAttributes {
                    return !visibleItemsIndexPath.contains(layoutAttributes.indexPath)
                }
                return false
            }
            
            for item in behaviorsToRemove {
                
                self.dynamicAnimator.removeBehavior(item)
                
                if let layoutAttributes = item.items.first as? UICollectionViewLayoutAttributes {
                
                    self.visibleIndexPaths.remove(layoutAttributes.indexPath)
                }
            }
        }
    }
    
    func jsq_adjust(_ springBehavior: UIAttachmentBehavior, forTouchLocation touchLocation: CGPoint) {
        
        if let item = springBehavior.items.first as? UICollectionViewLayoutAttributes {
            
            var center = item.center
            if !touchLocation.equalTo(CGPoint.zero) {
                
                let distanceFromTouch: CGFloat = abs(touchLocation.y - springBehavior.anchorPoint.y)
                let scrollResistance = distanceFromTouch/self.springResistanceFactor
                
                if self.latestDelta < 0 {
                    
                    center.y += max(self.latestDelta, self.latestDelta * scrollResistance)
                }
                else {
                    
                    center.y += min(self.latestDelta, self.latestDelta * scrollResistance)
                }
                item.center = center
            }
        }
    }
}
