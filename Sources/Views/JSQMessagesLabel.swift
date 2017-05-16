//
//  JSQMessagesLabel.swift
//  JSQMessagesViewController
//
//

import UIKit

open class JSQMessagesLabel: UILabel {
    
    open var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    func jsq_configureLabel() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.textInsets = UIEdgeInsets.zero
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.jsq_configureLabel()
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.jsq_configureLabel()
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.jsq_configureLabel()
    }
    
    // MARK: - Drawing
    
    open override func drawText(in rect: CGRect) {
        
        super.drawText(in: CGRect(x: rect.minX + self.textInsets.left, y: rect.minY + self.textInsets.top, width: rect.width - self.textInsets.right, height: rect.height - self.textInsets.bottom))
    }
}
