//
//  WeatherForecast - Weather.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - Weather JSON Format
class WeatherJSON: Decodable {
    let weatherForecast: [WeatherForecastInfo]
    let city: City
}

// MARK: - List
class WeatherForecastInfo: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: Weather
    let dtTxt: String
}

// MARK: - MainClass
class MainInfo: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity, pop: Double
}

// MARK: - Weather
class Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - City
class City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: TimeInterval
}

// MARK: - Coord
class Coord: Decodable {
    let lat, lon: Double
}

// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    var expression: String {
        guard let expression = expressionMapping[self.rawValue] else { return ""}
        return expression.rawValue
    }
    
    var desc: String {
        switch self {
        case .metric:
            return "섭씨"
        case .imperial:
            return "화씨"
        }
    }
    
    private var expressionMapping: [String: TempExpression] {
        return [
            TempUnit.metric.rawValue: .metric,
            TempUnit.imperial.rawValue: .imperial
        ]
    }
}

enum TempExpression: String {
    case metric = "℃"
    case imperial = "℉"
}

