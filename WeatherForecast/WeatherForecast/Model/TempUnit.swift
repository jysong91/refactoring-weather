//
//  TempUnit.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/17/24.
//

import Foundation

// MARK: - Temperature Unit
enum TempUnit: String {
    case metric, imperial
    var expression: String {
        switch self {
        case .metric: return "℃"
        case .imperial: return "℉"
        }
    }
    
    var title: String {
        switch self {
        case .metric: return "화씨"
        case .imperial: return "섭씨"
        }
    }
}

final class TempUnitManager {
    static let shared = TempUnitManager()
    
    var currentUnit: TempUnit = .metric
    
    private init() {}
    
    func getCurrentUnitExpression() -> String {
        return currentUnit.expression
    }
    
    func getCurrentUnitTitle() -> String {
        return currentUnit.title
    }
    
    func changeTempUnit() {
        switch currentUnit {
        case .imperial:
            currentUnit = .metric
        case .metric:
            currentUnit = .imperial
        }
    }
}
