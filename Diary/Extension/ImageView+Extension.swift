//
//  ImageView+Extension.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/31.
//

import UIKit

extension UIImageView {
    func loadView(imageID: String) {
        let cacheKey = NSString(string: imageID)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        let request = WeatherRequest(baseURL: URLHost.weatherIcon.url, path: .weatherIcon(imageID))
        guard let url = request.url else { return }
        
        let session =  URLSession.shared
        session.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            guard let data = data,
            let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                self?.image = image
            }
        }.resume()
    }
}

