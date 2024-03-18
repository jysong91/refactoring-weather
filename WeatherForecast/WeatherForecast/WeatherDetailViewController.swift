//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController {
    private let infoProtocol: DetailViewInfoProtocol
    
    init(infoProtocol: DetailViewInfoProtocol) {
        self.infoProtocol = infoProtocol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    override func loadView() {view = DetailView(weatherForecastInfo: infoProtocol.weatherForecastInfo, cityInfo: infoProtocol.cityInfo, tempUnit: infoProtocol.tempUnit)
        layViews()
    }
    
    private func layViews() {
        view.backgroundColor = .white
        
        let weatherForecastInfo = infoProtocol.weatherForecastInfo
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        navigationItem.title = dateFormatter.string(from: date)
    }
}
