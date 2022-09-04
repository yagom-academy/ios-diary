//
//  ImageDownloader.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import UIKit

extension UIImageView {
    func setImageURL(_ url: String) -> URLSessionDataTask? {
        
        let cacheKey = NSString(string: url)
        var task: URLSessionDataTask?
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return nil
        }
        
        DispatchQueue.global().async {
            if let url = URL(string: url) {
         task = URLSession.shared.dataTask(with: url) { data, res, err in
                    if let _ = err {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data,
                           let image = UIImage(data: data) {
                            self.image = image
                        }
                    }
                }
                task?.resume()
            }
        }
        return task
    }
}
