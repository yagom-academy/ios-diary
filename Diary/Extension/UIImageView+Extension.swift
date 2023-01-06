//
//  UIImageView+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2023/01/06.
//

import UIKit

extension UIImageView {
    func loadView(imageID: String) {
        let cachedKey = NSString(string: imageID)
        
        if let cachedImage = ImageDataCacheManager.shared.object(forKey: cachedKey) {
            self.image = cachedImage
            return
        }
        
        guard let url = APIManager.weatherImage(iconID: imageID).urlComponents.url else { return }
        
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
                ImageDataCacheManager.shared.setObject(image,
                                                       forKey: cachedKey)
                self?.image = image
            }
        }.resume()
    }
}
