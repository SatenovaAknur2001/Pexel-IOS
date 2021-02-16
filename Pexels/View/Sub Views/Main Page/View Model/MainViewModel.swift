//
//  MainViewModel.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/21/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewModelDelegate: class {
    func reloadData()
    func showError()
}

class MainViewModel {
    var photos: [Photo] = []
    var currentPageInFeed = 1
    weak var delegate: MainViewModelDelegate?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func getNumberOfItems() -> Int { photos.count}
    
    func getCachedImage(at row: Int) -> UIImage? {
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileURL = cache?.appendingPathComponent("\(photos[row].id).jpg")
        guard let file = fileURL else { return nil}
        return UIImage(contentsOfFile: file.path)
    }
    
    func getSizeOfItem(at row: Int) -> CGSize {
        return CGSize(width: CGFloat(photos[row].width), height: CGFloat(photos[row].height))
    }
    
    func getItem(at row: Int) -> Photo { return photos[row] }
    
    func populateFeed () {
        let request = APIRequest(method: .get, path: "curated")
        request.headers = [
            HTTPHeader(field: "Authorization", value: "563492ad6f917000010000012cc5bdd065b342dc8da323c4bb729667")
        ]
        request.queryItems = [
            URLQueryItem(name: "per_page", value: "15"),
            URLQueryItem(name: "page", value: "\(currentPageInFeed)")
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
                self?.delegate?.reloadData()
                self?.currentPageInFeed += 1
            } catch let parseError as NSError {
                self?.delegate?.showError()
                print("JSONDecoder error: \(parseError.localizedDescription)\n")
            }
        }
    }
    
    func isBookmarked(_ id: Int) -> Bool { appDelegate.exists(id: id) }
}

