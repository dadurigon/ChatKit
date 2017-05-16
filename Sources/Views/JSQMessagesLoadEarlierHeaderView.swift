//
//  JSQMessagesLoadEarlierHeaderView.swift
//  JSQMessagesViewController
//
//

import UIKit

public protocol JSQMessagesLoadEarlierHeaderViewDelegate {
    
    func headerView(_ headerView: JSQMessagesLoadEarlierHeaderView, didPressLoadButton sender: UIButton?)
}

open class JSQMessagesLoadEarlierHeaderView: UICollectionReusableView {
    
    static var kJSQMessagesLoadEarlierHeaderViewHeight: CGFloat = 32
    var delegate: JSQMessagesLoadEarlierHeaderViewDelegate?
    
    @IBOutlet var loadButton: UIButton!
    
    open class func nib() -> UINib {
        
        return UINib(nibName: JSQMessagesLoadEarlierHeaderView.jsq_className, bundle: Bundle(for: JSQMessagesLoadEarlierHeaderView.self))
    }
    
    open class func headerReuseIdentifier() -> String {
        
        return JSQMessagesLoadEarlierHeaderView.jsq_className
    }
    
    // MARK: - Initialization
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.clear
        
        self.loadButton.setTitle(Bundle.jsq_localizedStringForKey("load_earlier_messages"), for: UIControlState())
        self.loadButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    // MARK: - Reusable view
    
    open override var backgroundColor: UIColor? {
        
        didSet {
            
            self.loadButton.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        
        self.delegate?.headerView(self, didPressLoadButton: sender)
    }
}

