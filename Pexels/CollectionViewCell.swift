//
//  CollectionViewCell.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/12/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit
import SnapKit

class FeedCellViewController: UICollectionViewCell {
    
    static let id = "CollectionViewCellID"
    
    var cellMargin: CGFloat = 50
    var mainImage = UIImageView()
    var authorName = UILabel()
    var authorPhoto = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        contentView.addSubview(mainImage)
        contentView.addSubview(authorPhoto)
        contentView.addSubview(authorName)
        
        updateMainImage()
        updateAuthorPhoto()
        updateAuthorName()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMainImage() {
        mainImage.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 0, bottom: cellMargin, right: 0))
        }
    }
    
    func updateAuthorPhoto() {
        authorPhoto.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainImage.snp.bottom).offset((cellMargin * 0.3) / 2)
            make.bottom.equalTo(contentView).offset(-(cellMargin * 0.3) / 2)
            make.width.equalTo(cellMargin * 0.7)
            make.leading.equalTo(contentView).offset(cellMargin * 0.4)
        }
        
        authorPhoto.backgroundColor = .systemGray4
        authorPhoto.layer.masksToBounds = true
        authorPhoto.layer.cornerRadius = (cellMargin * 0.7) / 2
        
        authorPhoto.textColor = .white
        authorPhoto.textAlignment = .center
    }
    
    func updateAuthorName() {
        authorName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainImage.snp.bottom).offset((cellMargin * 0.3) / 2)
            make.bottom.equalTo(contentView).offset(-(cellMargin * 0.3) / 2)
            make.leading.equalTo(authorPhoto.snp.trailing).offset(cellMargin * 0.4)
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
        }
        authorName.font = UIFont(name: "GillSans", size: 18)
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

