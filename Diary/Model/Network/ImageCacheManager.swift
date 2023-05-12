//
//  ImageCacheManager.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/12.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
