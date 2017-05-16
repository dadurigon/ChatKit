//
//  JSQActionSelectView.swift
//  JSQMessagesSwift
//
//
//

import UIKit

public protocol JSQActionSelectViewDelegate {
    func didSelectView( atIndex index: Int)
}

open class JSQActionSelectView: UIView {
    
    @IBOutlet var collectionView: UICollectionView!
    var delegate: JSQActionSelectViewDelegate?
    internal var sourse : [(image: UIImage, title: String)]!
    internal var columns: CGFloat = 3.0
    internal var insert: CGFloat = 0
    internal var spacing: CGFloat = 0
    internal var lineSpacing: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
        self.setupCollectionView()
    }
    
    // MARK: - Private
    private func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "JSQActionSelectView", bundle: bundle)
        
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            let bindings = ["view": view]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                          options: NSLayoutFormatOptions(rawValue: 0),
                                                          metrics: nil,
                                                          views: bindings))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                          options: NSLayoutFormatOptions(rawValue: 0),
                                                          metrics: nil,
                                                          views: bindings))
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.register( UINib(nibName: "JSQActionViewCell", bundle: Bundle.jsq_messagesBundle()), forCellWithReuseIdentifier: "JSQActionViewCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    
}


extension JSQActionSelectView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sourse.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JSQActionViewCell", for: indexPath) as! JSQActionViewCell
        cell.image.image = self.sourse[indexPath.row].image
        cell.title.text = self.sourse[indexPath.row].title
        return cell
    }
}

extension JSQActionSelectView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let with = (collectionView.frame.width / columns) - (insert + spacing)
        
        return CGSize(width: with, height: with - 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insert, left: insert, bottom: insert, right: insert)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
}

extension JSQActionSelectView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectView(atIndex: indexPath.row)
    }
    
}

