//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var weatherJSON: WeatherJSON?
    var icons: [UIImage]?
    let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    var tempUnit: TempUnit = .metric
    var weatherView: WeatherView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func loadView() {
        weatherView = WeatherView(delegate: self,
                                  dataSource: self)
        view = weatherView
    }
}

extension WeatherViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
            navigationItem.rightBarButtonItem?.title = "섭씨"
        case .metric:
            tempUnit = .imperial
            navigationItem.rightBarButtonItem?.title = "화씨"
        }
        refresh()
    }
    
    @objc private func refresh() {
        fetchWeatherJSON()
        weatherView?.tableViewReloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
        
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        weatherView?.setTableViewRefreshControl(refreshControl: refreshControl)
    }
    
 
}

extension WeatherViewController {
    private func fetchWeatherJSON() {
        
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = NSDataAsset(name: "weather")?.data else {
            return
        }
        
        let info: WeatherJSON
        do {
            info = try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        weatherJSON = info
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.updateCell(with: weatherForecastInfo,
                        tempUnit: tempUnit)
        
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

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
        detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        detailViewController.cityInfo = weatherJSON?.city
        detailViewController.tempUnit = tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}


