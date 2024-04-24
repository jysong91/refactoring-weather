//
//  DiskCache.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/21/24.
//

import UIKit


final class DiskCache: ImageCachable {
    private let fileManager: FileManager = FileManager.default
    private let directoryURL: URL
    private let countLimit: Int
    
    init(countLimit: Int = 50) {
        self.countLimit = countLimit
        self.directoryURL = try! fileManager.url(for: .cachesDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                   create: true)
    }
    
    private func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
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
        
        if countStoredCaches() >= countLimit {
            removeOldCache()
        }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error writing image to disk: \(error)")
        }
    }
    
    private func countStoredCaches() -> Int {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            return fileURLs.count
        } catch {
            return 0
        }
    }
    
    
    private func removeOldCache() {
        guard let oldestFileURL = try? fileManager.contentsOfDirectory(at: directoryURL,
                                                                       includingPropertiesForKeys: nil).first else {
            return
        }
        
        do {
            try fileManager.removeItem(at: oldestFileURL)
        } catch {
            print("Error removing oldest item from disk cache: \(error)")
        }
    }
    
}
