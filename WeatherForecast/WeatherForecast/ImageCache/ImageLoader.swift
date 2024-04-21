//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

final class ImageLoader {
    
    static func loadImage(for urlString: String) async -> UIImage? {
        return await ImageCacheManager.shared.image(for: urlString)
    }
}
