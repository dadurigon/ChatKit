//
//  JSQPhotoMediaItem.swift
//  JSQMessagesViewController
//
//

import Foundation
import UIKit


open class JSQPhotoMediaItem: JSQMediaItem {
    
    fileprivate var _image: UIImage?
    open var image: UIImage? {
        
        get {
            
            return self._image
        }
        set {
            
            if self._image == newValue {
                
                return
            }
            
            self._image = newValue?.copy() as? UIImage
            self.cachedImageView = nil
        }
    }
    
    fileprivate var cachedImageView: UIImageView?
    
    // MARK: - Initialization
    
    public required init() {
        
        super.init()
    }

    public required init(image: UIImage?) {
        
        super.init(maskAsOutgoing: true)
        
        self.image = image?.copy() as? UIImage
    }

    public required init(maskAsOutgoing: Bool) {

        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    open override var appliesMediaViewMaskAsOutgoing: Bool {
        
        didSet {
            
            self.cachedImageView = nil
        }
    }
    
    override func clearCachedMediaViews() {

        super.clearCachedMediaViews()
        
        self.cachedImageView = nil
    }
    
    // MARK: - JSQMessageMediaData protocol
    
    open override var mediaView: UIView? {

        get {
            
            if let _ = self.cachedImageView {
                
                return self.cachedImageView
            }
            
            if let image = self.image {
                
                let size = self.mediaViewDisplaySize
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                
                JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
                self.cachedImageView = imageView
                
                return self.cachedImageView
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
    
    open override var hash:Int {
        
        get {
            
            return super.hash^(self.image?.hash ?? 0)
        }
    }
    
    open override var description: String {
        
        get {
            
            return "<\(type(of: self)): image=\(String(describing: self.image)) appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"
        }
    }
    
    // MARK: - NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.image = aDecoder.decodeObject(forKey: "image") as? UIImage
    }
    
    open override func encode(with aCoder: NSCoder) {
        
        super.encode(with: aCoder)
        
        aCoder.encode(self.image, forKey: "image")
    }
    
    // MARK: - NSCopying
    
    open override func copy(with zone: NSZone?) -> Any {
        
        let copy = type(of: self).init(image: UIImage(cgImage: self.image!.cgImage!))
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing
        return copy
    }
}
