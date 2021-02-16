//
//  FeaturedViewController.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/18/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController {
    private let const: CGFloat = 4.0
    private let cellMargin: CGFloat = 50.0
    private var currentPageInSearchResults = 1
    private var errorLabel: UILabel = {
        let temp = UILabel()
        temp.font = UIFont(name: "Arial", size: 24)
        temp.textColor = .systemGray2
        temp.textAlignment = .center
        temp.isHidden = true
        return temp
    }()
    private let featuredViewModel = FeaturedViewModel()

    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        var temp = UICollectionViewFlowLayout()
        temp.minimumLineSpacing = const
        temp.minimumInteritemSpacing = const
        return temp
    }()

    lazy var featuredCollectionView: UICollectionView = {
        var temp = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        temp.backgroundColor = .systemGray4
        temp.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.id)
        return temp
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(_ notificationNames: [Notification.Name]) {
        super.init(nibName: nil, bundle: nil)
        for item in notificationNames {
            NotificationCenter.default.addObserver(self, selector: #selector(updateFeatured), name: item, object: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        featuredViewModel.fetchData()
        if featuredViewModel.getNumberOfItems() == 0 {
            showError("No featured images")
        } else {
            errorLabel.isHidden = true
        }
        featuredCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        featuredCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        
        configureFeaturedCollectionView()
        configureErrorLabel()
    }
    
    @objc func updateFeatured(notification : Notification) {
        featuredViewModel.updateFeatured(notification: notification as NSNotification)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func configureFeaturedCollectionView() {
        view.addSubview(featuredCollectionView)
        featuredCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(view.frame.width * 0.7)
            make.height.equalTo(view.frame.height * 0.1)
        }
    }
}

extension FeaturedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredViewModel.getNumberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = featuredCollectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.id, for: indexPath) as? FeaturedCollectionViewCell
        let item = featuredViewModel.getItem(at: indexPath.row)
        guard
            let cell = collectionViewCell,
            let large = item.large,
            let url = URL(string: large),
            let photographer = item.photographer
        else {
            return UICollectionViewCell()
        }

        cell.mainImageView.image = nil
        cell.authorNameLabel.text = item.photographer

        if let image = featuredViewModel.getCachedImage(at: indexPath.row) {
            cell.mainImageView.image = image
        } else {
            cell.mainImageView.getImageWithURL(url: url, withIdentifier: "\(item.id)")
        }
        cell.delegate = self
        cell.imageID = Int(item.id)
        cell.authorPhotoLabel.text = String(photographer.prefix(1))
        cell.bookmarkButton.isSelected = featuredViewModel.isBookmarked(Int(item.id))
        return cell
    }

}

extension FeaturedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: -Make Clickable
    }
}

extension FeaturedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = featuredViewModel.getSizeOfItem(at: indexPath.row)
        let newWidth = UIScreen.main.bounds.width
        let newHeight = (newWidth / itemSize.width) * itemSize.height + 10 + cellMargin
        return CGSize(width: newWidth, height: newHeight)
    }
}

// Deleteion Cell Inside
extension FeaturedViewController: FeaturedCellDelegate {
    func delete(cell: FeaturedCollectionViewCell) {
        guard let indexPath = featuredCollectionView.indexPath(for: cell) else { return}
        featuredViewModel.removeItem(at: indexPath.row)
        featuredCollectionView.deleteItems(at: [indexPath])
        if featuredViewModel.getNumberOfItems() == 0 {
            showError("No featured images")
        } else {
            errorLabel.isHidden = true
        }
    }
}

