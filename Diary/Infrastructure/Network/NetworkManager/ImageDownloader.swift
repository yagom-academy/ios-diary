//
//  ImageDownloader.swift
//  Diary
//
//  Created by 조민호 on 2022/06/30.
//

import UIKit

final class ImageDownloader {
    private let networkManager = NetworkManager()
    private let imageCacheManager = ImageCacheManager()
    private var task: URLSessionDataTask?
    
    func cancelTask() {
        task?.suspend()
        task?.cancel()
    }
    
    func requestImage(
        icon: String,
        completion: @escaping (UIImage) -> Void
    ) {
        if let cacheImage = imageCacheManager.retrive(forKey: icon) {
            completion(cacheImage)
            return
        }
        
        let endpoint = EndpointStorage
            .weatherIcon(icon)
            .endPoint
        
        task = requestImageAPI(with: endpoint) { [weak self] (result: Result<UIImage, Error>) in
            switch result {
            case .success(let image):
                self?.imageCacheManager.set(object: image, forKey: icon)
                completion(image)
            case .failure:
                guard let image = UIImage(systemName: "questionmark.square.dashed") else {
                    return
                }
                completion(image)
            }
        }
    }
    
    @discardableResult
    private func requestImageAPI(
        with endpoint: Requestable,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> URLSessionDataTask? {
        return networkManager.request(endpoint: endpoint) { result in
            switch result {
            case .success(let result):
                guard let image = UIImage(data: result) else {
                    completion(.failure(NetworkError.emptyDataError))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
