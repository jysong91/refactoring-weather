//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

enum CacheOption {
    case onlyMemory
    case onlyDisk
    case both
    case nothing
}

actor ImageCacheManager {
  
    static let shared = ImageCacheManager()
    private let memoryCache: MemoryCache = MemoryCache()
    private let diskCache: DiskCache = DiskCache()
    private var option: CacheOption = .both
    
    init(_ option: CacheOption = .both) {
        self.option = option
    }
    
    func image(for key: String) async -> UIImage? {
        if let memoryImage = loadMemoryCache(for: key) {
            return memoryImage
        }
        
        if let diskImage = loadDiskCache(for: key) {
            self.storeMemoryCache(for: key, image: diskImage)
            return diskImage
        }
        
        if let downloadImage = await ImageDownloader.downloadImage(from: key) {
            self.storeMemoryCache(for: key, image: downloadImage)
            self.storeDiskCache(for: key, image: downloadImage)
            return downloadImage
        }
        
        return nil
    }
    
    private func loadMemoryCache(for key: String) -> UIImage? {
        return memoryCache.value(for: key)
    }
    
    private func loadDiskCache(for key: String) -> UIImage? {
        return diskCache.value(for: key)
    }
    
    private func storeMemoryCache(for key: String, image: UIImage) {
        if option == .both || option == .onlyMemory {
            memoryCache.store(for: key, image: image)
        }
    }
    
    private func storeDiskCache(for key: String, image: UIImage) {
        if option == .both || option == .onlyDisk {
            diskCache.store(for: key, image: image)
        }
    }
    
}
