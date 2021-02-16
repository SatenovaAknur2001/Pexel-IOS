//
//  SearchResultsViewController.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/14/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    private let const: CGFloat = 4.0
    private let cellMargin: CGFloat = 50.0
    let searchResultsViewModel = SearchResultsViewModel()
    private let errorLabel: UILabel = {
        let temp = UILabel()
        temp.font = UIFont(name: "Arial", size: 24)
        temp.textColor = .systemGray
        temp.textAlignment = .center
        temp.isHidden = true
        return temp
    }()
    
    lazy var feedCollectionView: UICollectionViewFlowLayout = {
        var temp = UICollectionViewFlowLayout()
        temp.minimumLineSpacing = const
        temp.minimumInteritemSpacing = const
        return temp
    }()
    lazy var searchResultsCollectionView: UICollectionView = {
        var temp = UICollectionView(frame: .zero, collectionViewLayout: self.feedCollectionView)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = .systemGray4
        temp.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
        return temp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultsViewModel.populateSearchResults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchResultsViewModel.delegate = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        configureSearchResultsCollectionView()
        configureErrorLabel()
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func configureSearchResultsCollectionView() {
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.snp.makeConstraints { (make) -> Void in
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

extension SearchResultsViewController: SearchResultsViewModelDelegate {
    func showError() {
        showError("No matching results")
    }
    
    func reloadData() {
        searchResultsCollectionView.reloadData()
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsViewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCellViewController = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as? FeedCollectionViewCell
        let item = searchResultsViewModel.getItem(at: indexPath.row)
        
        guard
            let cell = feedCellViewController,
            let url = URL(string: item.src.large)
        else {
            return FeedCollectionViewCell()
        }
        
        cell.mainImageView.image = nil
        cell.authorNameLabel.text = item.photographer
        if let image = searchResultsViewModel.getCachedImage(at: indexPath.row) {
            cell.mainImageView.image = image
        } else {
            cell.mainImageView.getImageWithURL(url: url, withIdentifier: "\(item.id)")
        }
        cell.authorPhotoLabel.text = String(item.photographer.prefix(1))
        cell.photo = item
        cell.bookmarkButton.isSelected = searchResultsViewModel.isBookmarked(item.id)
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResultsViewModel.getItem(at: indexPath.row)
        let vc = PhotoViewController(photo: item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == searchResultsViewModel.getNumberOfItems() - 10 {
            searchResultsViewModel.populateSearchResults()
        }
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = searchResultsViewModel.getSizeOfItem(at: indexPath.row)
        let newWidth = UIScreen.main.bounds.width
        let newHeight = (newWidth / itemSize.width) * itemSize.height + 10 + cellMargin
        return CGSize(width: newWidth, height: newHeight)
    }
}

