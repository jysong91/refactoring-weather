//
//  Date+extension.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/15/24.
//

import Foundation

extension Date {
    var toWeatherDateString: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter.string(from: self)
    }
}
