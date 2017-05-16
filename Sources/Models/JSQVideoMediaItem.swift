//
//  JSQVideoMediaItem.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit

open class JSQVideoMediaItem: JSQMediaItem {
    
    open var fileURL: URL? {
        
        didSet {
            
            self.cachedVideoImageView = nil
        }
    }
    
    open var isReadyToPlay: Bool = false {
        
        didSet {
            
            self.cachedVideoImageView = nil
        }
    }
    
    fileprivate var cachedVideoImageView: UIImageView?
    
    // MARK: - Initialization
    
    public required init() {
        
        super.init()
    }
    
    public required init(fileURL: URL?, isReadyToPlay: Bool) {
        
        self.fileURL = fileURL
        self.isReadyToPlay = isReadyToPlay
        self.cachedVideoImageView = nil

        super.init()
    }
    
    public required init(maskAsOutgoing: Bool) {
        
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    open override var appliesMediaViewMaskAsOutgoing: Bool {
        
        didSet {
            
            self.cachedVideoImageView = nil
        }
    }
    
    override func clearCachedMediaViews() {
        
        super.clearCachedMediaViews()
        
        self.cachedVideoImageView = nil
    }
    
    // MARK: - JSQMessageMediaData protocol
    
    open override var mediaView: UIView? {
        
        get {
            
            if !self.isReadyToPlay {
                
                return nil
            }

            if let _ = self.fileURL {
                
                if let _ = self.cachedVideoImageView {
                    
                    return self.cachedVideoImageView
                }
                
                let size = self.mediaViewDisplaySize
                let playIcon = UIImage.jsq_defaultPlayImage()?.jsq_imageMaskedWithColor(UIColor.lightGray)
                let imageView = UIImageView(image: playIcon)
                imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                imageView.contentMode = .center
                imageView.clipsToBounds = true
                
                JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
                self.cachedVideoImageView = imageView
                
                return self.cachedVideoImageView
            }
            
            return nil
        }
    }
    
    open override var mediaHash: Int {
        
        get {
            
            return self.hash
        }
    }
    
    // MARK: - NSObject
    
    open override func isEqual(_ object: Any?) -> Bool {
        
        if !super.isEqual(object) {
            
            return false
        }
        
        if let videoItem = object as? JSQVideoMediaItem {
            
            return self.fileURL == videoItem.fileURL && self.isReadyToPlay == videoItem.isReadyToPlay
        }
        
        return false
    }
    
    open override var hash:Int {
        
        get {
            
            return super.hash^((self.fileURL as NSURL?)?.hash ?? 0)
        }
    }
    
    open override var description: String {
        
        get {
            
            return "<\(type(of: self)):  fileURL=\(String(describing: self.fileURL)), isReadyToPlay=\(self.isReadyToPlay), appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"
        }
    }
    
    // MARK: - NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        self.fileURL = aDecoder.decodeObject(forKey: "fileURL") as? URL
        self.isReadyToPlay = aDecoder.decodeBool(forKey: "isReadyToPlay")
        
        super.init(coder: aDecoder)
    }
    
    open override func encode(with aCoder: NSCoder) {
        
        super.encode(with: aCoder)
        
        aCoder.encode(self.fileURL, forKey: "fileURL")
        aCoder.encode(self.isReadyToPlay, forKey: "isReadyToPlay")
    }
    
    // MARK: - NSCopying
    
    open override func copy(with zone: NSZone?) -> Any {
        
        let copy = type(of: self).init(fileURL: self.fileURL, isReadyToPlay: self.isReadyToPlay)
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing
        return copy
    }
}
