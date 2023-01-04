//
//  ImageDataCacheManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/01/04.
//

import Foundation

final class ImageDataCacheManager {
    static let shared = NSCache<NSString, NSData>()
    
    private init() {}
}
