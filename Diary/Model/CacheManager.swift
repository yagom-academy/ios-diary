//
//  CacheManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/06.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
