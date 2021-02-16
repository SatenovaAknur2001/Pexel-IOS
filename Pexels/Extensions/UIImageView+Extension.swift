//
//  UIImageView+Extension.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/16/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImageWithURL(url: URL, withIdentifier: String) {
        URLSession.shared.downloadTask(with: url) { [weak self] url, response, error in
            guard
                let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
                let url = url
            else {
                return
            }
            do {
                let file = cache.appendingPathComponent("\(withIdentifier).jpg")
                try FileManager.default.moveItem(atPath: url.path, toPath: file.path)
                DispatchQueue.main.async {
                    self?.image = UIImage(contentsOfFile: file.path)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
