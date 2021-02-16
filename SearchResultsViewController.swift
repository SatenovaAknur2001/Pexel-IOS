//
//  SearchResultsViewController.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/14/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit
import Alamofire

class SearchResultsViewController: UIViewController {
    var resource = Resources()
    private let const: CGFloat = 4.0
    private let cellMargin: CGFloat = 50.0
    private var currentPageInSearchResults = 1
    var searchingText = String()
    
    lazy var layout: UICollectionViewFlowLayout = {
        var temp = UICollectionViewFlowLayout()
        temp.minimumLineSpacing = const
        temp.minimumInteritemSpacing = const
        return temp
    }()
    
    lazy var searchResultsCollectionView: UICollectionView = {
        var temp = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = .systemGray4
        temp.register(FeedCellViewController.self, forCellWithReuseIdentifier: FeedCellViewController.id)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    func populateResourcesInSearchResults() {
        let parameters = ["query" : searchingText, "per_page" : 15, "page" : currentPageInSearchResults] as [String : Any]
        AF.request(
            "https://api.pexels.com/v1/search",
            method: .get,
            parameters: parameters,
            headers: HTTPHeaders(["Authorization" : "563492ad6f917000010000012cc5bdd065b342dc8da323c4bb729667"])
        ).validate().responseDecodable(of: SearchResult.self) { (response) in
            if let results = response.value {
                self.resource.items += results.photos
                self.searchResultsCollectionView.reloadData()
                self.currentPageInSearchResults += 1
            }
        }
    }
    
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultsCollectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCellViewController.id,
            for: indexPath
            ) as! FeedCellViewController
        cell.mainImage.image = nil
        cell.authorName.text = resource.items[indexPath.row].photographer
        
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let file = cache?.appendingPathComponent("\(resource.items[indexPath.row].id).jpg")
        if let image = UIImage(contentsOfFile: file!.path) {
            cell.mainImage.image = image
        } else {
            cell.mainImage.getImageWithURL(url: URL(string: resource.items[indexPath.row].src.large)!, withIdentifier: "\(resource.items[indexPath.row].id)")
        }
        cell.authorPhoto.text = String(resource.items[indexPath.row].photographer.prefix(1))
        
        cell.gradientLayer.colors = resource.colors.randomElement()
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: -Make Clickable
        let item = resource.items[indexPath.item]
        let vc = PhotoViewController(photo: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == resource.items.count - 10 {
            populateResourcesInSearchResults()
        }
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (UIScreen.main.bounds.width / CGFloat(resource.items[indexPath.row].width)) * CGFloat(resource.items[indexPath.row].height)
        return CGSize(width: UIScreen.main.bounds.width, height: height + 10 + cellMargin)
    }
}

