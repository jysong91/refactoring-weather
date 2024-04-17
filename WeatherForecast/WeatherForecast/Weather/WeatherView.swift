//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/17/24.
//

import UIKit

protocol WeatherViewDelegate {
    func presentWeatherDetail(weatherForecastInfo: WeatherForecastInfo?, cityInfo: City?)
}

final class WeatherView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        return tableView
    }()
    
    private var weatherJSON: WeatherJSON?
    private var icons: [UIImage]?
    private let imageChache: NSCache<NSString, UIImage> = NSCache()
    let delegate: WeatherViewDelegate
    
    init(delegate: WeatherViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        layoutView()
        setTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setTableViewRefreshControl(refreshControl: UIRefreshControl) {
        tableView.refreshControl = refreshControl
    }
    
    func tableViewReloadData(with weatherJSON: WeatherJSON) {
        self.weatherJSON = weatherJSON
        tableView.reloadData()
    }
}

extension WeatherView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.updateCell(with: weatherForecastInfo)
        
        let iconName: String = weatherForecastInfo.weather.icon
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        if let image = imageChache.object(forKey: urlString as NSString) {
            cell.weatherIcon.image = image
            return cell
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            imageChache.setObject(image, forKey: urlString as NSString)
            
            if indexPath == tableView.indexPath(for: cell) {
                cell.weatherIcon.image = image
            }
        }
      
        return cell
    }
}

extension WeatherView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.presentWeatherDetail(weatherForecastInfo: weatherJSON?.weatherForecast[indexPath.row],
                                      cityInfo: weatherJSON?.city)
    }
}


