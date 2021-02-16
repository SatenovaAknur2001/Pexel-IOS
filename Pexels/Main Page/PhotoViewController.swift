//
//  PhotoViewController.swift
//  Pexels
//
//  Created by Акнур on 8/22/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    private let photo: Photo
    var mainImage = UIImageView()
    var imageHeight: CGFloat = 0.0 {
        willSet {
            mainImage.snp.makeConstraints{ make in
                make.top.equalTo(view).offset(50)
                make.bottom.equalTo(view.snp.top).offset(50 + newValue)
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
            }
        }
    }
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainImage)
        
        imageHeight = (UIScreen.main.bounds.width / CGFloat(photo.width)) * CGFloat(photo.height)
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let file = cache?.appendingPathComponent("\(photo.id).jpg")
        if let image = UIImage(contentsOfFile: file!.path) {
            mainImage.image = image
        } else {
            mainImage.getImageWithURL(url: URL(string: photo.src.large)!, withIdentifier: "\(photo.id)")
        }
        let saveBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(saveAction))
        let shareBarButtonItem = UIBarButtonItem(title: "share", style: .done, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItems = [saveBarButtonItem, shareBarButtonItem]
    }
    
    @objc func saveAction() {
        guard let image = mainImage.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @objc func shareAction() {
        let url = URL(string: photo.url)!
        let ac = UIActivityViewController(activityItems: [url] ,
                                          applicationActivities: nil)
        self.present(ac,animated: true)
    }
    
    
}




