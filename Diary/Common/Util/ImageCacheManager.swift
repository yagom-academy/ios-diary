//
//  ImageCacheManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import UIKit

final class ImageCacheManager {
  static let shared = NSCache<NSString, UIImage>()
  private init() {}
}
