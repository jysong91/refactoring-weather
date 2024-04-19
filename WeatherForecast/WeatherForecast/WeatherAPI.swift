//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/17/24.
//

import UIKit

protocol WeatherServiceable {
    func fetchWeatherJSON() async throws -> WeatherJSON
}

final class WeatherAPI: WeatherServiceable {
    func fetchWeatherJSON() async throws -> WeatherJSON {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            throw NetworkError.responesError
        }
        
        var info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            throw NetworkError.decodeError
        }
        
        return info
    }
  
}
