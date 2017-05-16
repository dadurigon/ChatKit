//
//  ChatViewController.swift
//  JSQMessagesSwift
//
//

import JSQMessagesSwift
import UIKit
import MapKit

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        self.senderId = "1234"
        self.senderDisplayName = "Dang"
        
        self.setupUI()
        self.dummyData()
    }
    
    func setupUI() {
        
        let image = UIImage(named: "background")
        let imgBackground:UIImageView = UIImageView(frame: self.view.bounds)
        imgBackground.image = image
        imgBackground.contentMode = UIViewContentMode.scaleAspectFill
        imgBackground.clipsToBounds = true
        self.collectionView?.backgroundView = imgBackground
        
        let view = JSQAccessoryButton(frame: CGRect(x: 0, y: 0, width: 30  , height: 30))
        let action1 = (image: UIImage.jsq_PhotoLibrary()!, title: "Library", action: { print("Photo") })
        let action2 = (image: UIImage.jsq_Camera()!, title: "Camera", action: { print("Camera") })
        let action3 = (image: UIImage.jsq_Location()!, title: "Location", action: { print("Location") })
        view.sourses = [action1, action2, action3]
        view.setImage(UIImage(named: "thumbnail"), for: .normal)
        self.inputToolbar.contentView.leftBarButtonItem = view
        self.keyboardController.actionButton = view
        
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(image: UIImage(named:"avatar-1")!, diameter: 120)
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(image: UIImage(named:"avatar-2")!, diameter: 120)
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.outgoingBubble = bubbleFactory.outgoingMessagesBubbleImage(color: UIColor.jsq_messageBubbleGreenColor())
        self.incomingBubble = bubbleFactory.incomingMessagesBubbleImage(color: UIColor.jsq_messageBubbleLightGrayColor())
        
    }
    
    func dummyData() {
        
        let photo = JSQPhotoMediaItem(image: UIImage(named: "thumbnail"))
        let mes0 = JSQMessage(senderId: "1234", senderDisplayName: "Dang", date: Date(), media: photo)
        let mes1 = JSQMessage(senderId: "123", senderDisplayName: "DANG", date: Date(), text: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
        let mes2 = JSQMessage(senderId: "1234", senderDisplayName: "nobody", date: Date(), text: "QQQQQQQQQQQQQQQQQQ")
        let location = CLLocation(latitude: 35.6369673747966, longitude: 139.715670326304)
        let localItem = JSQLocationMediaItem(maskAsOutgoing: true)
        localItem.set(location, completion: {
            self.collectionView.reloadData()
        })
        let mes3 = JSQMessage(senderId: "1234", senderDisplayName: "Dang", date: Date(), media: localItem)
        let mes4 = JSQMessage(senderId: "124", senderDisplayName: "DANG", date: Date(), text: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
        let mes5 = JSQMessage(senderId: "123", senderDisplayName: "DANG", date: Date(), text: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
        let mes6 = JSQMessage(senderId: "1234", senderDisplayName: "DANG", date: Date(), text: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")

        self.messages = [mes1, mes0, mes2, mes3, mes4, mes5, mes6]
        
    }
    override func didPressSendButton(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        let mes = JSQMessage(senderId: "1234", senderDisplayName: "Dang", date: Date(), text: text)
        self.messages.append(mes)
        self.showTypingIndicator = true
        self.finishSendingMessage()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Scroll")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = self.messages[indexPath.row]
        if message.senderId != self.senderId {
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return self.messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        let message = self.messages[indexPath.item]
        
        return message.senderId == self.senderId ? self.outgoingBubble : self.incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = self.messages[indexPath.item]
        
        return message.senderId == self.senderId ? self.outgoingAvatar : self.incomingAvatar
        
    }
    
}

