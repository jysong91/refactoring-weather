//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ImageCache {
    static let shared: NSCache<NSString, UIImage> = NSCache()
    private init() {}
}

class WeatherListViewController: UIViewController {
    
    var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var weatherJSON: WeatherJSON?
    var icons: [UIImage]?
    let dateFormatter: DateFormatter = DateFormatter(format: "yyyy-MM-dd(EEEEE) a HH:mm")
    
    var tempUnit: TempUnit = .metric
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

extension WeatherListViewController {
    @objc private func changeTempUnit() {
        switch tempUnit {
        case .imperial:
            tempUnit = .metric
        case .metric:
            tempUnit = .imperial
        }
        navigationItem.rightBarButtonItem?.title = tempUnit.desc
        refresh()
    }
    
    @objc private func refresh() {
        fetchWeatherJSON()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: tempUnit.desc, image: nil, target: self, action: #selector(changeTempUnit))
        
        layTable()
        setTable()
        refresh()
    }
    
    private func layTable() {
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
    
    private func setTable() {
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension WeatherListViewController {
    private func fetchWeatherJSON() {
        
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = NSDataAsset(name: "weather")?.data else { return }
        
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
    
    private func setData(cell: WeatherTableViewCell, data: WeatherForecastInfo) {
        cell.weatherLabel.text = data.weather.main
        cell.descriptionLabel.text = data.weather.description
        cell.temperatureLabel.text = "\(data.main.temp)\(tempUnit.expression)"
        cell.dateLabel.text = dateFormatter.string(from: data.dt)
        cell.weatherIcon.setImage(from: data.weather.icon)
    }
}

extension WeatherListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherJSON?.weatherForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo: WeatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }

        setData(cell: cell, data: weatherForecastInfo)
        
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController()
        detailViewController.weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row]
        detailViewController.cityInfo = weatherJSON?.city
        detailViewController.tempUnit = tempUnit
        navigationController?.show(detailViewController, sender: self)
    }
}

extension DateFormatter {
    convenience init(format: String?) {
        self.init()
        self.locale = .init(identifier: "ko_KR")
        self.dateFormat = format
    }
    
    func string(from timeInterval: TimeInterval) -> String {
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        return self.string(from: date)
    }
}

extension UIImageView {
    func setImage(from iconName: String, cache: NSCache<NSString, UIImage>? = ImageCache.shared) {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        if let cache = cache, let image = cache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        
        Task {
            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }
            
            cache?.setObject(image, forKey: urlString as NSString)
            self.image = image
        }
    }
}
