//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

final class ImageCacheManager {
  
    static let shared = ImageCacheManager()
    private let memoryCache: MemoryCache = MemoryCache()
    private let diskCache: DiskCache = DiskCache()
    
    func image(for key: String) async -> UIImage? {
        if let image = imageWithMemoryCache(for: key) {
            return image
        } else {
            return await imageWithDiskCache(for: key)
        }
    }
    
    private func imageWithMemoryCache(for key: String) -> UIImage? {
        return memoryCache.value(for: key)
    }
    
    private func imageWithDiskCache(for key: String) async -> UIImage? {
        if let image = try? diskCache.value(for: key) {
            store(for: key, image: image, includeDisk: false)
            return image
        } else {
            if let image = await ImageDownloader.downloadImage(from: key) {
                self.store(for: key, image: image, includeDisk: true)
            }
            
            return nil
        }
    }
    
    private func store(for key: String, image: UIImage, includeDisk: Bool) {
        memoryCache.store(for: key, image: image)
        
        if includeDisk {
            try? diskCache.store(for: key, image: image)
        }
    }
    
}
