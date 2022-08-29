//
//  UIImage+Extensions.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/29.
//

import UIKit

extension UIImage {
    static func fetch(url: String) -> UIImage? {
        var uiImage: UIImage?
        
        guard let url = URL(string: url) else {
            return nil
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            uiImage = image
        }.resume()
        
        return uiImage
    }
}
