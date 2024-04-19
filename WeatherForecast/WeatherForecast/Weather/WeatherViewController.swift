//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var weatherView: WeatherView?
    private var api: WeatherServiceable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    init(api: WeatherServiceable) {
        self.api = api
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        weatherView = WeatherView(delegate: self)
        view = weatherView
    }
}

extension WeatherViewController {
    @objc private func changeTempUnit() {
        TempUnitManager.shared.changeTempUnit()
        navigationItem.rightBarButtonItem?.title = TempUnitManager.shared.getCurrentUnitTitle()
        refresh()
    }
    
    @objc private func refresh() {
        Task {
            await fetchWeatherAPI()
            refreshControl.endRefreshing()
        }
    }
    
    private func fetchWeatherAPI() async {
        do {
            let weatherJSON = try await api.fetchWeatherJSON()
            weatherView?.tableViewReloadData(with: weatherJSON)
            navigationItem.title = weatherJSON.city.name
        } catch {
            let error = error as? NetworkError
            let errorMessage: String
            switch error {
            case .responesError:
                errorMessage = "응답 처리 중 오류가 발생했습니다."
            case .decodeError:
                errorMessage = "데이터 처리 중 오류가 발생했습니다."
            case nil:
                errorMessage = "알 수 없는 오류가 발생했습니다."
            }
            Util.showAlert(viewController: self,
                           title: "오류",
                           message: errorMessage,
                           buttonTitle: "확인")
        }
    }
    
    private func initialSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(changeTempUnit))
        
        
        
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        
        weatherView?.setTableViewRefreshControl(refreshControl: refreshControl)
    } 
}

extension WeatherViewController: WeatherViewDelegate {
    func presentWeatherDetail(weatherForecastInfo: WeatherForecastInfo?, cityInfo: City?) {
        guard let weatherForecastInfo = weatherForecastInfo,
                  let cityInfo = cityInfo else { return }
        let detailViewController: WeatherDetailViewController = WeatherDetailViewController(
            weatherForecastInfo: weatherForecastInfo,
            cityInfo: cityInfo)
        navigationController?.show(detailViewController, sender: self)
    }
}
