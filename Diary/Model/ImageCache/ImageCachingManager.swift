//
//  ImageCachingManager.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/09/13.
//

import UIKit

class ImageCachingManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
