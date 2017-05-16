//
//  JSQMessagesViewController.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesViewController: UIViewController, JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, UITextViewDelegate, JSQMessagesInputToolbarDelegate, JSQMessagesKeyboardControllerDelegate {
    
    @IBOutlet fileprivate(set) open var collectionView: JSQMessagesCollectionView!
    @IBOutlet fileprivate(set) open var inputToolbar: JSQMessagesInputToolbar!
    
    @IBOutlet var toolbarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var toolbarBottomLayoutGuide: NSLayoutConstraint!
    
    open var keyboardController: JSQMessagesKeyboardController!
    
    open var senderId: String = ""
    open var senderDisplayName: String = ""
    
    open var automaticallyScrollsToMostRecentMessage: Bool = true
    
    open var outgoingCellIdentifier: String = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
    open var outgoingMediaCellIdentifier: String = JSQMessagesCollectionViewCellOutgoing.mediaCellReuseIdentifier()

    
    open var incomingCellIdentifier: String = JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier()
    open var incomingMediaCellIdentifier: String = JSQMessagesCollectionViewCellIncoming.mediaCellReuseIdentifier()
    
    open var showTypingIndicator: Bool = false {
        
        didSet {
            
            self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    open var showLoadEarlierMessagesHeader: Bool = false {
        
        didSet {
            
            self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    open var topContentAdditionalInset: CGFloat = 0 {
        
        didSet {
            
            self.jsq_updateCollectionViewInsets()
        }
    }
    
    fileprivate var snapshotView: UIView?
    fileprivate var jsq_isObserving: Bool = false
    fileprivate let kJSQMessagesKeyValueObservingContext: UnsafeMutableRawPointer? = nil
    
    fileprivate var selectedIndexPathForMenu: IndexPath?
    
    // MARK: - Initialization
    
    func jsq_configureMessagesViewController() {
        
        self.view.backgroundColor = UIColor.white
        
        self.toolbarHeightConstraint.constant = self.inputToolbar.preferredDefaultHeight
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.inputToolbar.delegate = self
        self.inputToolbar.contentView.textView.placeHolder = Bundle.jsq_localizedStringForKey("new_message")
        self.inputToolbar.contentView.textView.delegate = self
        
        self.automaticallyScrollsToMostRecentMessage = true
        
        self.outgoingCellIdentifier = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
        self.outgoingMediaCellIdentifier = JSQMessagesCollectionViewCellOutgoing.mediaCellReuseIdentifier()
        
        self.incomingCellIdentifier = JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier()
        self.incomingMediaCellIdentifier = JSQMessagesCollectionViewCellIncoming.mediaCellReuseIdentifier()
        
        self.showTypingIndicator = false
        
        self.showLoadEarlierMessagesHeader = false
        
        self.topContentAdditionalInset = 0
        
        self.jsq_updateCollectionViewInsets()
        
        self.keyboardController = JSQMessagesKeyboardController(textView: self.inputToolbar.contentView.textView, contextView: self.view, panGestureRecognizer: self.collectionView.panGestureRecognizer, delegate: self)
    }
    
    // MARK: - Class methods 
    
    open class func nib() -> UINib {
        
        return UINib(nibName: JSQMessagesViewController.jsq_className, bundle: Bundle.jsq_messagesBundle())
    }
    
    open static func messagesViewController() -> JSQMessagesViewController {

        return self.init(nibName: JSQMessagesViewController.jsq_className, bundle: Bundle.jsq_messagesBundle())
    }
    
    // MARK: - View lifecycle
    
    public required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        type(of: self).nib().instantiate(withOwner: self, options: nil)
        
        self.jsq_configureMessagesViewController()
        self.jsq_registerForNotifications(true)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.senderId == "" {
            
            print("senderID must not be nil \(#function)")
            abort()
        }
        if self.senderDisplayName == "" {
            
            print("senderDisplayName must not be nil \(#function)")
            abort()
        }
        
        self.view.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        if self.automaticallyScrollsToMostRecentMessage {
            
            DispatchQueue.main.async {
                
                self.scrollToBottom(animated: false)
                self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        
        self.jsq_updateKeyboardTriggerPoint()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.jsq_addObservers()
        self.jsq_addActionToInteractivePopGestureRecognizer(true)
        self.keyboardController.beginListeningForKeyboard()
        
        if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
            
            self.snapshotView?.removeFromSuperview()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.jsq_addActionToInteractivePopGestureRecognizer(false)
        self.collectionView.messagesCollectionViewLayout.springinessEnabled = false
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        self.keyboardController.endListeningForKeyboard()
    }
    
    open override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        print("MEMORY WARNING: \(#function)")
    }
    
    // MARK: - View rotation
    
    open override var shouldAutorotate : Bool {
        
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        if UIDevice.current.userInterfaceIdiom == .phone {

            return .allButUpsideDown
        }
        return .all
    }
    
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        
        if self.showTypingIndicator {
            
            self.showTypingIndicator = false
            self.showTypingIndicator = true
            
            self.collectionView.reloadData()
        }
        
    }
    
    
    // MARK: - Messages view controller
    
    open func didPressSendButton(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        print("ERROR: required method not implemented in subclass. Need to implement \(#function)")
//        abort()
    }

    open func didPressAccessoryButton(_ sender: UIButton) {
        
        print("ERROR: required method not implemented in subclass. Need to implement \(#function)")
//        abort()
    }
    
    open func finishSendingMessage() {
        
        self.finishSendingMessage(animated: true)
    }
    
    open func finishSendingMessage(animated: Bool) {
        
        let textView = self.inputToolbar.contentView.textView
        textView?.text = nil
        textView?.undoManager?.removeAllActions()
        
        self.inputToolbar.toggleSendButtonEnabled()
        
        NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: textView)
        
        self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        self.collectionView.reloadData()
        
        if self.automaticallyScrollsToMostRecentMessage && !self.jsq_isMenuVisible() {
            
            self.scrollToBottom(animated: animated)
        }
    }
    
    open func finishReceivingMessage() {
        
        self.finishReceivingMessage(animated: true)
    }
    
    open func finishReceivingMessage(animated: Bool) {
        
        self.showTypingIndicator = false
        
        self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        self.collectionView.reloadData()
        
        if self.automaticallyScrollsToMostRecentMessage && !self.jsq_isMenuVisible() {
            
            self.scrollToBottom(animated: animated)
        }
    }
    
    open func scrollToBottom(animated: Bool) {
        
        if self.collectionView.numberOfSections == 0 {
            
            return
        }
        
        if self.collectionView.numberOfItems(inSection: 0) == 0 {
            
            return
        }
        
        let collectionViewContentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        let isContentTooSmall = collectionViewContentHeight < self.collectionView.bounds.height
        
        if isContentTooSmall {
            
            self.collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionViewContentHeight - 1, width: 1, height: 1), animated: animated)
            return
        }
        
        let finalRow = max(0, self.collectionView.numberOfItems(inSection: 0) - 1)
        let finalIndexPath = IndexPath(row: finalRow, section: 0)
        let finalCellSize = self.collectionView.messagesCollectionViewLayout.sizeForItem(finalIndexPath)
        
        let maxHeightForVisibleMessage = self.collectionView.bounds.height - self.collectionView.contentInset.top - self.inputToolbar.bounds.height
        let scrollPosition: UICollectionViewScrollPosition = finalCellSize.height > maxHeightForVisibleMessage ? .bottom : .top
        
        self.collectionView.scrollToItem(at: finalIndexPath, at: scrollPosition, animated: animated)
    }
    
    // MARK: - JSQMessages collection view data source
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        
        print("ERROR: required method not implemented: \(#function)")
        abort()
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        print("ERROR: required method not implemented: \(#function)")
        abort()
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        
        print("ERROR: required method not implemented: \(#function)")
        abort()
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAt indexPath: IndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    // MARK: - Collection view data source
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dataSource = collectionView.dataSource as! JSQMessagesCollectionViewDataSource
        let flowLayout = collectionView.collectionViewLayout as! JSQMessagesCollectionViewFlowLayout
        
        let messageItem = dataSource.collectionView(self.collectionView, messageDataForItemAt: indexPath)
        
        let messageSendId = messageItem.senderId
        let isOutgoingMessage = messageSendId == self.senderId
        let isMediaMessage = messageItem.isMediaMessage
        
        var cellIdentifier = isOutgoingMessage ? self.outgoingCellIdentifier : self.incomingCellIdentifier
        if isMediaMessage {
            
            cellIdentifier = isOutgoingMessage ? self.outgoingMediaCellIdentifier : self.incomingMediaCellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! JSQMessagesCollectionViewCell
        
        if !isMediaMessage {
            
            cell.textView?.text = messageItem.text
            
            if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
                
                cell.textView?.text = nil
                cell.textView?.attributedText = NSAttributedString(string: messageItem.text ?? "", attributes: [
                    NSFontAttributeName: flowLayout.messageBubbleFont
                ])
            }
            
            let bubbleImageDataSource = dataSource.collectionView(self.collectionView, messageBubbleImageDataForItemAt: indexPath)
            cell.messageBubbleImageView?.image = bubbleImageDataSource.messageBubbleImage
            cell.messageBubbleImageView?.highlightedImage = bubbleImageDataSource.messageBubbleHighlightedImage
        }
        else {
            let messageMedia = messageItem.media!
            cell.mediaView = messageMedia.mediaView != nil ? messageMedia.mediaView: messageMedia.mediaPlaceholderView
        }
        
        var needsAvatar = true
        if isOutgoingMessage && flowLayout.outgoingAvatarViewSize.equalTo(CGSize.zero) {
            
            needsAvatar = false
        }
        else if !isOutgoingMessage && (collectionView.collectionViewLayout as! JSQMessagesCollectionViewFlowLayout).incomingAvatarViewSize.equalTo(CGSize.zero) {
            
            needsAvatar = false
        }
        
        var avatarImageDataSource: JSQMessageAvatarImageDataSource?
        if needsAvatar {
            
            avatarImageDataSource = dataSource.collectionView(self.collectionView, avatarImageDataForItemAt: indexPath)
            if let avatarImageDataSource = avatarImageDataSource {
                
                if let avatarImage = avatarImageDataSource.avatarImage {
                    
                    cell.avatarImageView.image = avatarImage
                    cell.avatarImageView.highlightedImage = avatarImageDataSource.avatarHighlightedImage
                }
                else {
                    
                    cell.avatarImageView.image = avatarImageDataSource.avatarPlaceholderImage
                    cell.avatarImageView.highlightedImage = nil
                }
                
            }
        }
        
        cell.cellTopLabel.attributedText = dataSource.collectionView?(self.collectionView, attributedTextForCellTopLabelAt: indexPath)
        cell.messageBubbleTopLabel.attributedText = dataSource.collectionView?(self.collectionView, attributedTextForMessageBubbleTopLabelAt: indexPath)
        cell.cellBottomLabel.attributedText = dataSource.collectionView?(self.collectionView, attributedTextForCellBottomLabelAt: indexPath)
        
        let bubbleTopLabelInset: CGFloat = avatarImageDataSource != nil ? 60 : 15
        
        if isOutgoingMessage {
            
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, bubbleTopLabelInset)
        }
        else {
            
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, bubbleTopLabelInset, 0, 0)
        }
        
        cell.textView?.dataDetectorTypes = .all
        
        cell.backgroundColor = UIColor.clear
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.layer.shouldRasterize = true
        
        let time = messageItem.date.jsq_Mmdd()
        cell.sendTimeLabel.text = time
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if self.showTypingIndicator && kind == UICollectionElementKindSectionFooter {
            
            return self.collectionView.dequeueTypingIndicatorFooterView(indexPath)
        }
        
        // self.showLoadEarlierMessagesHeader && kind == UICollectionElementKindSectionHeader
        return self.collectionView.dequeueLoadEarlierMessagesViewHeader(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if !self.showTypingIndicator {
            
            return CGSize.zero
        }
        
        return CGSize(width: (collectionViewLayout as? JSQMessagesCollectionViewFlowLayout)?.itemWidth ?? 0, height: JSQMessagesTypingIndicatorFooterView.kJSQMessagesTypingIndicatorFooterViewHeight)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if !self.showLoadEarlierMessagesHeader {
            
            return CGSize.zero
        }
        
        return CGSize(width: (collectionViewLayout as? JSQMessagesCollectionViewFlowLayout)?.itemWidth ?? 0, height: JSQMessagesLoadEarlierHeaderView.kJSQMessagesLoadEarlierHeaderViewHeight)
    }
    
    // MARK: - Collection view delegate
    
    open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        if let messageItem = (collectionView.dataSource as? JSQMessagesCollectionViewDataSource)?.collectionView(self.collectionView, messageDataForItemAt: indexPath) {
            
            if messageItem.isMediaMessage {
                
                return false
            }
        }
        
        self.selectedIndexPathForMenu = indexPath
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? JSQMessagesCollectionViewCell {
            
            selectedCell.textView?.isSelectable = false
        }
        
        return true
    }
    
    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            
            return true
        }
        
        return false
    }
    
    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {

            if let messageData = (collectionView.dataSource as? JSQMessagesCollectionViewDataSource)?.collectionView(self.collectionView, messageDataForItemAt: indexPath) {
                
                UIPasteboard.general.string = messageData.text
            }
        }
    }
    
    // MARK: - Collection view delegate flow layout
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return (collectionViewLayout as! JSQMessagesCollectionViewFlowLayout).sizeForItem(indexPath)
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        return 10
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        return 0
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAt indexPath: IndexPath) -> CGFloat {
        
        return 0
    }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, didTapAvatarImageView imageView: UIImageView, atIndexPath indexPath: IndexPath) { }
    
    open func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath) { }

    open func collectionView(_ collectionView: JSQMessagesCollectionView, didTapCellAt indexPath: IndexPath, touchLocation: CGPoint) { }

    // MARK: - Input toolbar delegate
    
    open func messagesInputToolbar(_ toolbar: JSQMessagesInputToolbar, didPressLeftBarButton sender: UIButton) {
        
        if toolbar.sendButtonOnRight {
            
            self.didPressAccessoryButton(sender)
        }
        else {
            
            self.didPressSendButton(sender, withMessageText: self.jsq_currentlyComposedMessageText(), senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date())
        }
    }
    
    open func messagesInputToolbar(_ toolbar: JSQMessagesInputToolbar, didPressRightBarButton sender: UIButton) {
        
        if toolbar.sendButtonOnRight {
            
            self.didPressSendButton(sender, withMessageText: self.jsq_currentlyComposedMessageText(), senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date())
        }
        else {
            
            self.didPressAccessoryButton(sender)
        }
    }
    
    func jsq_currentlyComposedMessageText() -> String {
    
        self.inputToolbar.contentView.textView.inputDelegate?.selectionWillChange(self.inputToolbar.contentView.textView)
        self.inputToolbar.contentView.textView.inputDelegate?.selectionDidChange(self.inputToolbar.contentView.textView)
        
        return self.inputToolbar.contentView.textView.text.jsq_stringByTrimingWhitespace()
    }
    
    // MARK: - Text view delegate
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView != self.inputToolbar.contentView.textView {
            
            return
        }
        
        textView.becomeFirstResponder()
        
        if self.automaticallyScrollsToMostRecentMessage {
            
            self.scrollToBottom(animated: true)
        }
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        
        if textView != self.inputToolbar.contentView.textView {
            
            return
        }
        
        self.inputToolbar.toggleSendButtonEnabled()
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView != self.inputToolbar.contentView.textView {
            
            return
        }
        
        textView.resignFirstResponder()
    }
    
    // MARK: - Notifications
    
    func jsq_handleDidChangeStatusBarFrameNotification(_ notification: Notification) {
        
        if self.keyboardController.keyboardIsVisible {
            
            self.jsq_setToolbarBottomLayoutGuideConstant(self.keyboardController.currentKeyboardFrame.height)
        }
    }
    
    func jsq_didReceiveMenuWillShowNotification(_ notification: Notification) {
        
        if let selectedIndexPathForMenu = self.selectedIndexPathForMenu {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
            
            if let menu = notification.object as? UIMenuController {
                
                menu.setMenuVisible(false, animated: false)
                
                if let selectedCell = self.collectionView.cellForItem(at: selectedIndexPathForMenu) as? JSQMessagesCollectionViewCell {
                    
                    let selectedCellMessageBubbleFrame = selectedCell.convert(selectedCell.messageBubbleContainerView.frame, to: self.view)
                    
                    menu.setTargetRect(selectedCellMessageBubbleFrame, in: self.view)
                    menu.setMenuVisible(true, animated: true)
                }
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesViewController.jsq_didReceiveMenuWillShowNotification(_:)), name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
        }
    }
    
    func jsq_didReceiveMenuWillHideNotification(_ notification: Notification) {
        
        if let selectedIndexPathForMenu = self.selectedIndexPathForMenu,
            let selectedCell = self.collectionView.cellForItem(at: selectedIndexPathForMenu) as? JSQMessagesCollectionViewCell {
            
            selectedCell.textView?.isSelectable = true
            self.selectedIndexPathForMenu = nil
        }
    }
    
    // MARK: - Key-value observing

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == self.kJSQMessagesKeyValueObservingContext {
            
            if let object = object as? UITextView {
                
                if object == self.inputToolbar.contentView.textView && keyPath == "contentSize" {
                    
                    if let oldContentSize = (change?[NSKeyValueChangeKey.oldKey] as AnyObject).cgSizeValue,
                        let newContentSize = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgSizeValue {

                        let dy = newContentSize.height - oldContentSize.height
                        
                        self.jsq_adjustInputToolbarForComposerTextViewContentSizeChange(dy)
                        self.jsq_updateCollectionViewInsets()
                        if self.automaticallyScrollsToMostRecentMessage {
                            
                            self.scrollToBottom(animated: false)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Keyboard controller delegate
    
    open func keyboardController(_ keyboardController: JSQMessagesKeyboardController, keyboardDidChangeFrame keyboardFrame: CGRect) {
        
        // MARK: DANG TEST
//        if !self.inputToolbar.contentView.textView.isFirstResponder && self.toolbarBottomLayoutGuide.constant == 0 {
//            
//            return
//        }
        
        
        var heightFromBottom = self.collectionView.frame.maxY - keyboardFrame.minY
        heightFromBottom = max(0, heightFromBottom)
        
        self.jsq_setToolbarBottomLayoutGuideConstant(heightFromBottom)
    }
    
    func jsq_setToolbarBottomLayoutGuideConstant(_ constant: CGFloat) {
    
        self.toolbarBottomLayoutGuide.constant = constant
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        self.jsq_updateCollectionViewInsets()
    }
    
    func jsq_updateKeyboardTriggerPoint() {
        
        self.keyboardController.keyboardTriggerPoint = CGPoint(x: 0, y: self.inputToolbar.bounds.height)
    }
    
    // MARK: - Gesture recognizers
    
    func jsq_handleInteractivePopGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
            case .began:
                if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
             
                    self.snapshotView?.removeFromSuperview()
                }
            
                self.keyboardController.endListeningForKeyboard()
            
                if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
                
                    self.inputToolbar.contentView.textView.resignFirstResponder()
                    UIView.animate(withDuration: 0, animations: { () -> Void in
                        
                        self.jsq_setToolbarBottomLayoutGuideConstant(0)
                    })
                    
                    let snapshot = self.view.snapshotView(afterScreenUpdates: true)
                    self.view.addSubview(snapshot!)
                    self.snapshotView = snapshot
                }
            case .changed:
                break
            case .ended, .cancelled, .failed:
            
                self.keyboardController.beginListeningForKeyboard()
            
                if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
                
                    self.snapshotView?.removeFromSuperview()
                }
            default:
                break
        }
    }
    
    // MARK: - Input toolbar utilities
    
    func jsq_inputToolbarHasReachedMaximumHeight() -> Bool {
        
        return self.inputToolbar.frame.minY == (self.topLayoutGuide.length + self.topContentAdditionalInset)
    }
    
    func jsq_adjustInputToolbarForComposerTextViewContentSizeChange(_ dy: CGFloat) {
        var dy = dy
        
        let contentSizeIsIncreasing = dy > 0
        
        if self.jsq_inputToolbarHasReachedMaximumHeight() {

            let contentOffsetIsPositive = (self.inputToolbar.contentView.textView.contentOffset.y > 0);
            
            if (contentSizeIsIncreasing || contentOffsetIsPositive) {

                self.jsq_scrollComposerTextViewToBottom(animated: true)
                return
            }
        }
        
        let toolbarOriginY = self.inputToolbar.frame.minY
        let newToolbarOriginY = toolbarOriginY - dy
        
        //  attempted to increase origin.Y above topLayoutGuide
        if newToolbarOriginY <= self.topLayoutGuide.length + self.topContentAdditionalInset {

            dy = toolbarOriginY - (self.topLayoutGuide.length + self.topContentAdditionalInset)
            self.jsq_scrollComposerTextViewToBottom(animated: true)
        }
        
        self.jsq_adjustInputToolbarHeightConstraintByDelta(dy)
        
        self.jsq_updateKeyboardTriggerPoint()
        
        if dy < 0 {
            
            self.jsq_scrollComposerTextViewToBottom(animated: false)
        }
    }
    
    func jsq_adjustInputToolbarHeightConstraintByDelta(_ dy: CGFloat) {
        
        let proposedHeight = self.toolbarHeightConstraint.constant + dy
        
        var finalHeight = max(proposedHeight, self.inputToolbar.preferredDefaultHeight)
        
        if self.inputToolbar.maximumHeight != NSNotFound {
            
            finalHeight = min(finalHeight, CGFloat(self.inputToolbar.maximumHeight))
        }
        
        if self.toolbarHeightConstraint.constant != finalHeight {
            
            self.toolbarHeightConstraint.constant = finalHeight
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    func jsq_scrollComposerTextViewToBottom(animated: Bool) {
        
        let textView = self.inputToolbar.contentView.textView
        let contentOffsetToShowLastLine = CGPoint(x: 0, y: (textView?.contentSize.height)! - (textView?.bounds.height)!)
        
        if !animated {
            
            textView?.contentOffset = contentOffsetToShowLastLine
            return
        }
        
        UIView.animate(withDuration: 0.01, delay: 0.01, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            textView?.contentOffset = contentOffsetToShowLastLine

        }, completion: nil)
    }
    
    // MARK: - Collection view utilities
    
    func jsq_updateCollectionViewInsets() {
        
        self.jsq_setCollectionViewInsets(topValue: self.topLayoutGuide.length + self.topContentAdditionalInset, bottomValue: self.collectionView.frame.maxY - self.inputToolbar.frame.minY)
    }
    
    func jsq_setCollectionViewInsets(topValue: CGFloat, bottomValue: CGFloat) {
        
        let insets = UIEdgeInsetsMake(topValue, 0, bottomValue, 0)
        self.collectionView.contentInset = insets
        self.collectionView.scrollIndicatorInsets = insets
    }
    
    func jsq_isMenuVisible() -> Bool {
        
        return self.selectedIndexPathForMenu != nil && UIMenuController.shared.isMenuVisible
    }
    
    // MARK: - Utilities
    
    func jsq_addObservers() {
        
        if self.jsq_isObserving {

            return
        }
        
        self.inputToolbar.contentView.textView.addObserver(self, forKeyPath: "contentSize", options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new], context: self.kJSQMessagesKeyValueObservingContext)
        
        self.jsq_isObserving = true
    }
    
    func jsq_removeObservers() {
        
        if !self.jsq_isObserving {
            
            return
        }
        
        self.inputToolbar.contentView.textView.removeObserver(self, forKeyPath: "contentSize", context: self.kJSQMessagesKeyValueObservingContext)
        
        self.jsq_isObserving = false
    }
    
    func jsq_registerForNotifications(_ register: Bool) {
        
        if register {
            
            NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesViewController.jsq_handleDidChangeStatusBarFrameNotification(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesViewController.jsq_didReceiveMenuWillShowNotification(_:)), name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(JSQMessagesViewController.jsq_didReceiveMenuWillHideNotification(_:)), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
        }
        else {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
        }
    }

    func jsq_addActionToInteractivePopGestureRecognizer(_ addAction: Bool) {
        
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            
            interactivePopGestureRecognizer.removeTarget(nil, action: #selector(JSQMessagesViewController.jsq_handleInteractivePopGestureRecognizer(_:)))
            
            if addAction {
                
                interactivePopGestureRecognizer.addTarget(self, action: #selector(JSQMessagesViewController.jsq_handleInteractivePopGestureRecognizer(_:)))
            }
        }
    }
}
