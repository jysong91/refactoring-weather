//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherViewController: UIViewController {
    let jsonFileName: String = "weather"
    
    var weatherJSON: WeatherJSON?
    
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    var tempUnit: TempUnit = .metric
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
        case .metric:
            tempUnit = .imperial
        }
        navigationItem.rightBarButtonItem?.title = tempUnit.strategy.title
        refresh()
    }
    
    @objc private func refresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        fetchWeatherJSON()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: tempUnit.strategy.title,
                                                            image: nil,
                                                            target: self,
                                                            action: #selector(changeTempUnit))
        
        setLayout()
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setLayout() {
        tableView = .init(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension WeatherViewController {
    private func fetchWeatherJSON() {
        
        guard let weatherInfo: WeatherJSON = JsonLoader.fetchJson(filename: jsonFileName) else { return }

        weatherJSON = weatherInfo
        navigationItem.title = weatherJSON?.city.name
    }
}

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(tempUnit.strategy.convertTemperture(metric: weatherForecastInfo.main.temp))\(tempUnit.strategy.unitSymbol)"
        
        let date: Date = Date(timeIntervalSince1970: weatherForecastInfo.dt)
        cell.dateLabel.text = date.toFormattedString()
                
            
        let imageUrlString: String = weatherForecastInfo.weather.iconPath
        
        if let image = imageChache.object(forKey: imageUrlString as NSString) {
            cell.weatherIcon.image = image
            return cell
        }
        
        Task {
            guard let image = await ImageLoader.loadUIImage(from: imageUrlString) else { return }
            
            imageChache.setObject(image, forKey: imageUrlString as NSString)
            
            if indexPath == tableView.indexPath(for: cell) {
                cell.weatherIcon.image = image
            }
        }
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(weatherForecastInfo: weatherJSON?.weatherForecast[indexPath.row],
                                                                                            cityInfo: weatherJSON?.city,
                                                                                            tempUnit: tempUnit)
    
        navigationController?.show(detailViewController, sender: self)
    }
}


