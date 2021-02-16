//
//  FeaturedCellViewController.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/20/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit
import SnapKit

protocol FeaturedCellDelegate: class {
    func delete(cell: FeaturedCollectionViewCell)
}

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    static let id = "FeaturedCellID"
    weak var delegate: FeaturedCellDelegate?

    private var cellMargin: CGFloat = 50
    var mainImageView = UIImageView()
    var authorNameLabel = UILabel()
    var authorPhotoLabel = UILabel()
    var bookmarkButton = UIButton()
    var imageID = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(authorPhotoLabel)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(bookmarkButton)
        
        updateMainImage()
        updateAuthorPhoto()
        updateAuthorName()
        updateBookmark()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateMainImage() {
        mainImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 0, bottom: cellMargin, right: 0))
        }
    }
    
    private func updateAuthorPhoto() {
        authorPhotoLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainImageView.snp.bottom).offset((cellMargin * 0.3) / 2)
            make.bottom.equalTo(contentView).offset(-(cellMargin * 0.3) / 2)
            make.width.equalTo(cellMargin * 0.7)
            make.leading.equalTo(contentView).offset(cellMargin * 0.4)
        }
        authorPhotoLabel.backgroundColor = .white
        authorPhotoLabel.textColor = .black
        authorPhotoLabel.textAlignment = .center
        authorPhotoLabel.layer.cornerRadius = cellMargin * 0.35
        authorPhotoLabel.layer.borderColor = UIColor(hex: "#20B483").cgColor
        authorPhotoLabel.layer.borderWidth = 1.0
    }
    
    private func updateAuthorName() {
        authorNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainImageView.snp.bottom).offset((cellMargin * 0.3) / 2)
            make.bottom.equalTo(contentView).offset(-(cellMargin * 0.3) / 2)
            make.leading.equalTo(authorPhotoLabel.snp.trailing).offset(cellMargin * 0.4)
            make.trailing.equalTo(contentView).offset(-cellMargin * 1.5)
        }
        authorNameLabel.font = UIFont(name: "GillSans", size: 18)
    }
    
    private func updateBookmark() {
        bookmarkButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainImageView.snp.bottom).offset((cellMargin * 0.3) / 2)
            make.bottom.equalTo(contentView).offset(-(cellMargin * 0.3) / 2)
            make.width.equalTo(cellMargin * 0.7)
            make.trailing.equalTo(contentView).offset(-cellMargin * 0.5)
        }
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "bookmark_selected"), for: .selected)
        
        bookmarkButton.imageView?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainImageView.snp.bottom).offset((cellMargin * 0.3) / 2)
            make.bottom.equalTo(contentView).offset(-(cellMargin * 0.3) / 2)
            make.width.equalTo(cellMargin * 0.5)
        }
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchDown)
    }
    
    @objc func bookmarkTapped() {
        if bookmarkButton.isSelected {
            delegate?.delete(cell: self)
            NotificationCenter.default.post(name: .deleted, object: nil, userInfo: ["id" : imageID])
            bookmarkButton.isSelected = false
        }
    }
}



