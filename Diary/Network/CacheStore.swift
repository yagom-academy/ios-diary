//
//  CacheStore.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/15.
//

import UIKit

final class CacheStore {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
