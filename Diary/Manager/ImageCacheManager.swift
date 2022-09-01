//
//  ImageCacheManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/31.
//

import Foundation
import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
