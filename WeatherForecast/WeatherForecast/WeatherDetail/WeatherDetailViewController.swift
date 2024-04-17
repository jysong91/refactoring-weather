//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherDetailViewController: UIViewController {

    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func loadView() {
        view = WeatherDetailView(weatherForecastInfo: weatherForecastInfo,
                                 cityInfo: cityInfo)
    }
    
    private func initialSetUp() {
        view.backgroundColor = .white
        
        guard let listInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        navigationItem.title = date.toWeatherDateString
    }
}
