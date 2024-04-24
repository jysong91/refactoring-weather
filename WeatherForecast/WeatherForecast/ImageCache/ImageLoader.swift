//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

final class ImageLoader {
    
    static func loadImage(for urlString: String) async -> UIImage? {
        if let cacheImage = await ImageCacheManager.shared.image(for: urlString) {
            return cacheImage
        }
        
        if let downloadImage = await ImageDownloader.downloadImage(from: urlString) {
            await ImageCacheManager.shared.storeMemoryCache(for: urlString, image: downloadImage)
            await ImageCacheManager.shared.storeDiskCache(for: urlString, image: downloadImage)
            return downloadImage
        }
        
        return nil
    }
}
