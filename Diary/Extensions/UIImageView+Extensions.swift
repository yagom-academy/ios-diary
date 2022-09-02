//
//  UIImageView+Extensions.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/29.
//

import UIKit

extension UIImageView {
    func fetch(url: String, completionHandler: @escaping (Result<UIImage, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.unknownErrorOccured))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.responseError))
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completionHandler(.failure(.failedToDecode))
                return
            }
            
            completionHandler(.success(image))
        }.resume()
    }
}
