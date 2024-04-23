//
//  DiskCache.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit


final class DiskCache: ImageCachable {
    private let fileManager: FileManager = FileManager.default
    
    init() {}
    
    private func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        let directoryURL = try? fileManager.url(for: .cachesDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                   create: true)
        return directoryURL?.appendingPathComponent(fileName, isDirectory: false) ?? URL(fileURLWithPath: "")
    }
    
    func value(for key: String) -> UIImage? {
        let fileURL = cacheFileURL(for: key)
        
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    func store(for key: String, image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let fileURL = cacheFileURL(for: key)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error writing image to disk: \(error)")
        }
    }
    
    
}
