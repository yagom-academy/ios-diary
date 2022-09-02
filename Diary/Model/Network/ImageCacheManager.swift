//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import UIKit

class ImageCacheManager {
    static let shared: NSCache<NSString, UIImage> = .init()
    
    private init() { }
}
