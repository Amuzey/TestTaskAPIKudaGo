//
//  UIImageView + Extension.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 15.05.2023.
//

import UIKit

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloadImage(from urlString: String, activityIndicator: UIActivityIndicatorView?) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            activityIndicator?.stopAnimating()
            return
        }
        DispatchQueue.global().async {
            guard let url = URL(string: urlString),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.image = image
                imageCache.setObject(image, forKey: urlString as NSString)
                activityIndicator?.stopAnimating()
            }
        }
    }
}
