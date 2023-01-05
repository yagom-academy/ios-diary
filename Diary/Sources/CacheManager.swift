//
//  CacheManager.swift
//  Diary
//
//  Copyright (c) 2023 Minii All rights reserved.


import UIKit

class CacheManager {
    static let share = CacheManager()
    
    var memoryCache = NSCache<NSString, UIImage>()
    var diskCache = FileManager.default
    
    private var folderURL: URL?
    
    private init() {
        createFolder()
    }
    
    func saveMemory(key: String?, image: UIImage) {
        guard let key = key else { return }
        let objectKey = NSString(string: key)
        
        memoryCache.setObject(image, forKey: objectKey)
    }
    
    func readMemory(key: String?) -> UIImage? {
        guard let key = key else { return nil }
        let objectKey = NSString(string: key)
        
        return memoryCache.object(forKey: NSString(string: objectKey))
    }
    
    private func createFolder() {
        let urls = diskCache.urls(for: .cachesDirectory, in: .userDomainMask)
        
        guard var url = urls.first,
              folderURL == nil else {
            return
            
        }
        
        url.appendPathComponent("Diary")
        try? diskCache.createDirectory(atPath: url.path, withIntermediateDirectories: true)
        folderURL = url
    }
    
    func saveDisk(key: String?, image: UIImage?) {
        guard let key = key,
              let folderURL = folderURL,
              let image = image else { return }
        
        let fileURL = folderURL.appendingPathComponent(key)
        
        let data = image.pngData()
        try? data?.write(to: fileURL)
    }
    
    func readDisk(key: String?) -> UIImage? {
        guard let key = key,
              let folderURL = folderURL else { return nil }
        
        let fileURL = folderURL.appendingPathComponent(key)
        guard let data = diskCache.contents(atPath: fileURL.path) else { return nil }
        
        return UIImage(data: data)
    }
}
