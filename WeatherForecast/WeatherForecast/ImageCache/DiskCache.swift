//
//  DiskCache.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit

final class DiskCache {
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
    
    func value(for key: String) throws -> UIImage? {
        let fileURL = cacheFileURL(for: key)
        
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
    }
    
    func store(for key: String, image: UIImage) throws {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
    }
    
    
}
