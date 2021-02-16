//
//  ViewController.swift
//  Pexels
//
//  Created by Mirzhan Gumarov on 8/10/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let const: CGFloat = 4.0
    private let cellMargin: CGFloat = 50.0
    private let mainViewModel = MainViewModel()
    private var searchResultsVC = SearchResultsViewController()
    private let errorLabel: UILabel = {
        let temp = UILabel()
        temp.font = UIFont(name: "Arial", size: 24)
        temp.textColor = .systemGray2
        temp.textAlignment = .center
        temp.isHidden = true
        return temp
    }()
    private var searchBar: UISearchBar = {
        let temp = UISearchBar()
        temp.placeholder = "Search for free photos and videos..."
        temp.showsCancelButton = true
        temp.tintColor = UIColor(hex: "#20B483")
        return temp
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        var temp = UICollectionViewFlowLayout()
        temp.minimumLineSpacing = const
        temp.minimumInteritemSpacing = const
        return temp
    }()
    
    private lazy var feedCollectionView: UICollectionView = {
        var temp = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        temp.backgroundColor = .systemGray4
        temp.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
        return temp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .white
        navigationItem.title = "Feed"
        navigationItem.titleView = searchBar
        
        mainViewModel.delegate = self
        searchBar.delegate = self
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        configureCollectionView()
        configureErrorLabel()
        
        mainViewModel.populateFeed()
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func configureCollectionView() {
        view.addSubview(feedCollectionView)
        feedCollectionView.snp.makeConstraints { (make) -> Void in
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

// View Model Extension
extension MainViewController: MainViewModelDelegate {
    func showError() {
        showError("Something went wrong :(")
    }
    
    func reloadData() {
        feedCollectionView.reloadData()
    }
}


// Search Bar Extension
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let text = searchBar.text else { return }
        searchResultsVC.searchResultsViewModel.photos = []
        searchResultsVC.searchResultsCollectionView.reloadData()
        searchResultsVC.searchResultsViewModel.searchingText = text
        searchBar.text = nil
        self.navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
    

// Collection Veiw Extensions
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCellViewController = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as? FeedCollectionViewCell
        let item = mainViewModel.getItem(at: indexPath.row)
        
        guard
            let cell = feedCellViewController,
            let url = URL(string: item.src.large)
        else {
            return FeedCollectionViewCell()
        }
        
        cell.mainImageView.image = nil
        cell.authorNameLabel.text = item.photographer
        
        if let image = mainViewModel.getCachedImage(at: indexPath.row) {
            cell.mainImageView.image = image
        } else {
            cell.mainImageView.getImageWithURL(url: url, withIdentifier: "\(item.id)")
        }
        cell.authorPhotoLabel.text = String(item.photographer.prefix(1))
        cell.photo = item
        cell.bookmarkButton.isSelected = mainViewModel.isBookmarked(item.id)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = mainViewModel.getItem(at: indexPath.row)
        let vc = PhotoViewController(photo: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == mainViewModel.getNumberOfItems() - 10 {
            mainViewModel.populateFeed()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = mainViewModel.getSizeOfItem(at: indexPath.row)
        let newWidth = UIScreen.main.bounds.width
        let newHeight = (newWidth / itemSize.width) * itemSize.height + 10 + cellMargin
        return CGSize(width: newWidth, height: newHeight)
    }
}

