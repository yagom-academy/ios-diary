//
//  ImageLoader.swift
//  Diary
//
//  Created by 이태영 on 2023/01/05.
//

import UIKit

protocol ImageNetworkService: NetworkService {
    var task: URLSessionDataTask? { get set }
    
    func loadImage(
        endPoint: Requesting,
        completion: @escaping (UIImage?) -> Void
    )
}

class ImageLoader: ImageNetworkService {
    var task: URLSessionDataTask? {
        didSet {
            task?.resume()
        }
    }
    
    func loadImage(
        endPoint: Requesting,
        completion: @escaping (UIImage?) -> Void
    ) {
        guard let request = endPoint.convertURL() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299) ~= response.statusCode else {
                completion(nil)
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }
        
        self.task = task
    }
}
