//
//  MemoryCache.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

final class MemoryCache: ImageCachable {
    
    private var cache = NSCache<NSString, UIImage>()
    
    init(countLimit: Int = 50) {
        cache.countLimit = countLimit
    }
    
    func value(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
