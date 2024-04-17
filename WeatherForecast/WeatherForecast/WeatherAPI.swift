//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/17/24.
//

import UIKit

protocol WeatherServiceable {
    func fetchWeatherJSON() async -> WeatherJSON?
}

final class WeatherAPI: WeatherServiceable {
    func fetchWeatherJSON() async -> WeatherJSON? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return nil
        }
        
        var info: WeatherJSON? = nil
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return info
    }
  
}
