//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {

    private let weatherForecastInfo: WeatherForecastInfo
    private let cityInfo: City
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func loadView() {
        view = WeatherDetailView(weatherForecastInfo: weatherForecastInfo,
                                 cityInfo: cityInfo)
    }
    
    init(weatherForecastInfo: WeatherForecastInfo,
         cityInfo: City) {
        self.weatherForecastInfo = weatherForecastInfo
        self.cityInfo = cityInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetUp() {
        view.backgroundColor = .white

        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        navigationItem.title = date.toWeatherDateString
    }
}
