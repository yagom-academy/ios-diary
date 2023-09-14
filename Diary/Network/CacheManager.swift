//
//  CacheManager.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/15.
//

import UIKit

class CacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
