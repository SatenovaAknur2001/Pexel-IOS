//
//  SearchResultsViewModel.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/21/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import Foundation
import UIKit

protocol SearchResultsViewModelDelegate: class {
    func reloadData()
    func showError()
}

class SearchResultsViewModel {
    var photos: [Photo] = []
    var searchingText = String()
    weak var delegate: SearchResultsViewModelDelegate?
    var currentPageInSearchResults = 1
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func populateSearchResults() {
        let request = APIRequest(method: .get, path: "search")
        request.headers = [HTTPHeader(field: "Authorization", value: "563492ad6f917000010000012cc5bdd065b342dc8da323c4bb729667")]
        request.queryItems = [
            URLQueryItem(name: "per_page", value: "15"),
            URLQueryItem(name: "page", value: "\(currentPageInSearchResults)"),
            URLQueryItem(name: "query", value: searchingText)
        ]
        
        APIClient().request(request) { [weak self] (response, data, error) in
            if let error = error {
                self?.delegate?.showError()
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                self?.delegate?.showError()
                return
            }
            do {
                let result = try JSONDecoder().decode(CuratedPhotos.self, from: data)
                self?.photos += result.photos
                if self?.photos.count == 0 { self?.delegate?.showError() }
                self?.delegate?.reloadData()
                self?.currentPageInSearchResults += 1
            } catch let parseError as NSError {
                self?.delegate?.showError()
                print("JSONDecoder error: \(parseError.localizedDescription)\n")
            }
        }
    }
    
    func getNumberOfItems() -> Int { photos.count}
    
    func getCachedImage(at row: Int) -> UIImage? {
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileURL = cache?.appendingPathComponent("\(photos[row].id).jpg")
        guard let file = fileURL else { return nil }
        return UIImage(contentsOfFile: file.path)
    }
    
    func getSizeOfItem(at row: Int) -> CGSize {
        return CGSize(width: CGFloat(photos[row].width), height: CGFloat(photos[row].height))
    }
    
    func getItem(at row: Int) -> Photo { return photos[row] }
    
    func isBookmarked(_ id: Int) -> Bool { appDelegate.exists(id: id) }
}
