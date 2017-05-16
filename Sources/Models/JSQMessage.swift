//
//  JSQMessage.swift
//  JSQMessagesViewController
//
//

import Foundation

open class JSQMessage: NSObject, JSQMessageData, NSCoding, NSCopying {
    
    fileprivate(set) open var senderId: String
    fileprivate(set) open var senderDisplayName: String
    fileprivate(set) open var date: Date
    
    fileprivate(set) open var isMediaMessage: Bool
    open var messageHash: Int {
        
        get {
            
            return self.hash
        }
    }
    
    fileprivate(set) open var text: String?
    fileprivate(set) open var media: JSQMessageMediaData?
    
    // MARK: - Initialization
    
    public required convenience init(senderId: String, senderDisplayName: String, date: Date, text: String) {
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMedia: false)
        self.text = text
    }
    
    open class func message(senderId: String, senderDisplayName: String, text: String) -> JSQMessage {
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: Date(), text: text)
    }
    
    public required convenience init(senderId: String, senderDisplayName: String, date: Date, media: JSQMessageMediaData) {
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMedia: true)
        self.media = media
    }
    
    open class func message(senderId: String, senderDisplayName: String, media: JSQMessageMediaData) -> JSQMessage {
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: Date(), media: media)
    }
    
    fileprivate init(senderId: String, senderDisplayName: String, date: Date, isMedia: Bool) {
        
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.isMediaMessage = isMedia
        
        super.init()
    }
    
    // MARK: - NSObject
    
    open override func isEqual(_ object: Any?) -> Bool {
        
        if !(object! as AnyObject).isKind(of: type(of: self)) {
            
            return false
        }
        
        if let msg = object as? JSQMessage {
        
            if self.isMediaMessage != msg.isMediaMessage {
                
                return false
            }
            
            let hasEqualContent: Bool = (self.isMediaMessage ? self.media?.isEqual(msg.media) : self.text == msg.text) ?? false
            
            return self.senderId == msg.senderId
                    && self.senderDisplayName == msg.senderDisplayName
                    && self.date.compare(msg.date) == .orderedSame
                    && hasEqualContent
        }
        
        return false
    }
    
    open override var hash:Int {
        
        get {
            
            let contentHash = self.isMediaMessage ? self.media?.mediaHash : self.text?.hash
            return self.senderId.hash^(self.date as NSDate).hash^contentHash!
        }
    }
    
    open override var description: String {
        
        get {
            
            return "<\(type(of: self)): senderId=\(self.senderId), senderDisplayName=\(self.senderDisplayName), date=\(self.date), isMediaMessage=\(self.isMediaMessage), text=\(String(describing: self.text)), media=\(String(describing: self.media))>"
        }
    }
    
    func debugQuickLookObject() -> AnyObject? {
        
        return self.media?.mediaPlaceholderView
    }
    
    // MARK: - NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        self.senderId = aDecoder.decodeObject(forKey: "senderID") as? String ?? ""
        self.senderDisplayName = aDecoder.decodeObject(forKey: "senderDisplayName") as? String ?? ""
        self.date = aDecoder.decodeObject(forKey: "date") as? Date ?? Date()
        
        self.isMediaMessage = aDecoder.decodeBool(forKey: "isMediaMessage")
        self.text = aDecoder.decodeObject(forKey: "text") as? String ?? ""
        
        self.media = aDecoder.decodeObject(forKey: "media") as? JSQMessageMediaData
    }
    
    open func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.senderId, forKey: "senderID")
        aCoder.encode(self.senderDisplayName, forKey: "senderDisplayName")
        aCoder.encode(self.date, forKey: "date")
        
        aCoder.encode(self.isMediaMessage, forKey: "isMediaMessage")
        aCoder.encode(self.text, forKey: "text")
        
        aCoder.encode(self.media, forKey: "media")
    }
    
    // MARK: - NSCopying
    
    open func copy(with zone: NSZone?) -> Any {
        
        if self.isMediaMessage {
            
            return type(of: self).init(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, media: self.media!)
        }
        
        return type(of: self).init(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, text: self.text!)
    }
}
