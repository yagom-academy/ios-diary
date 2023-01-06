//
//  ImageDataCacheManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2023/01/04.
//

import UIKit

final class ImageDataCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
