//
//  TempFormatter.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/19/24.
//

import Foundation

struct TempFormatter {
    
    func temperatureFormat(info: WeatherForecastInfo, tempUnit: TempUnit) -> String {
        return "\(info.main.temp)\(tempUnit.expression)"
    }
    
    func feelsLikeFormat(info: WeatherForecastInfo, tempUnit: TempUnit) -> String {
        return "\(info.main.feelsLike)\(tempUnit.expression)"
    }
    
    func maximumTemperatureFormat(info: WeatherForecastInfo, tempUnit: TempUnit) -> String {
        return "\(info.main.tempMax)\(tempUnit.expression)"
    }
    
    func minimumTemperatureFormat(info: WeatherForecastInfo, tempUnit: TempUnit) -> String {
        return "\(info.main.tempMin)\(tempUnit.expression)"
    }
    
}
