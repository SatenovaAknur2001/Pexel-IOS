//
//  StorageViewModel.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/21/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import Foundation

protocol StorageViewModelDelegate: class {
    func updateCacheAmount()
}

class StorageViewModel {
    weak var delegate: StorageViewModelDelegate?
    
    func getUpdatedCacheAmount() -> String {
        do {
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            if let sizeOnDisk = try documentDirectory.sizeOnDisk() {
                return sizeOnDisk
            }
        } catch {
            print(error.localizedDescription)
        }
        return "Zero KB"
    }
    
    func clearCache() {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        if let directory = cacheDirectory {
            do {
                let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
                for item in files {
                    try FileManager.default.removeItem(at: item)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        delegate?.updateCacheAmount()
    }
}
