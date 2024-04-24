//
//  TempFormatter.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/19/24.
//

import Foundation

struct TempFormatter {
    
    private let info: WeatherForecastInfo
    private let tempUnit: TempUnit
    
    init(info: WeatherForecastInfo, tempUnit: TempUnit) {
        self.info = info
        self.tempUnit = tempUnit
    }
    
    func temperatureFormat() -> String {
        return "\(info.main.temp)\(tempUnit.expression)"
    }
    
    func feelsLikeFormat() -> String {
        return "\(info.main.feelsLike)\(tempUnit.expression)"
    }
    
    func maximumTemperatureFormat() -> String {
        return "\(info.main.tempMax)\(tempUnit.expression)"
    }
    
    func minimumTemperatureFormat() -> String {
        return "\(info.main.tempMin)\(tempUnit.expression)"
    }
    
}
