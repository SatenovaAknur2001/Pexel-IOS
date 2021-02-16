//
//  FeaturedViewModel.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/21/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class FeaturedViewModel {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var featuredPhotos = [FeaturedPhoto]()
    
    func fetchData() {
        do {
            featuredPhotos = try context.fetch(FeaturedPhoto.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateFeatured(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let id = userInfo["id"] as? Int
        else {
            return
        }
        if notification.name == .deleted {
            let request = FeaturedPhoto.fetchRequest() as NSFetchRequest<FeaturedPhoto>
            request.predicate = NSPredicate(format: "id = %d", id)
            do {
                let results = try context.fetch(request) as [FeaturedPhoto]
                for object in results {
                    if object.id == id {
                        context.delete(object)
                        appDelegate.saveContext()
                    }
                }
            } catch let error {
                print("Deleting photo \(id) error :", error)
            }
        } else {
            let request = APIRequest(method: .get, path: "photos/\(id)")
            request.headers = [
                HTTPHeader(field: "Authorization", value: "563492ad6f917000010000012cc5bdd065b342dc8da323c4bb729667")
            ]
            
            APIClient().request(request) { [weak self] (response, data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else { return }
                do {
                    let image = try JSONDecoder().decode(Photo.self, from: data)
                    let featuredPhoto = FeaturedPhoto(entity: FeaturedPhoto.entity(), insertInto: self?.context)
                    featuredPhoto.height = image.height
                    featuredPhoto.width = image.width
                    featuredPhoto.id = Int64(image.id)
                    featuredPhoto.photographer = image.photographer
                    featuredPhoto.large = image.src.large
                    self?.appDelegate.saveContext()
                } catch let parseError as NSError {
                    print("JSONDecoder error: \(parseError.localizedDescription)\n")
                }
            }
        }
    }
    
    func getNumberOfItems() -> Int { featuredPhotos.count}
    
    func getCachedImage(at row: Int) -> UIImage? {
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileURL = cache?.appendingPathComponent("\(featuredPhotos[row].id).jpg")
        guard let file = fileURL else { return nil}
        return UIImage(contentsOfFile: file.path)
    }
    
    func getSizeOfItem(at row: Int) -> CGSize {
        return CGSize(width: CGFloat(featuredPhotos[row].width), height: CGFloat(featuredPhotos[row].height))
    }
    
    func removeItem(at row: Int) { featuredPhotos.remove(at: row) }
    
    func getItem(at row: Int) -> FeaturedPhoto { return featuredPhotos[row] }
    
    func isBookmarked(_ id: Int) -> Bool { appDelegate.exists(id: id) }
}
