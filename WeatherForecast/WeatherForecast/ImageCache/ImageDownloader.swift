//
//  ImageDownloader.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

struct ImageDownloader {
    
    static func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

