//
//  ImageCacheManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import UIKit

final class ImageCacheManager {
    private let cache = NSCache<NSString, UIImage>()
    
    func set(object: UIImage, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func retrive(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
