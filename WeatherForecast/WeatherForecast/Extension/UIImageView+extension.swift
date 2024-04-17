//
//  UIImageView+extension.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/17/24.
//

import UIKit

extension UIImageView {
    static private let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func loadImage(with urlString: String) {
        if let image = Self.imageChache.object(forKey: urlString as NSString) {
            self.image = image
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            Self.imageChache.setObject(image, forKey: urlString as NSString)
            
            self.image = image
        }
    }
}
