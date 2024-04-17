//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/17/24.
//

import UIKit

final class WeatherView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        return tableView
    }()
    
    init(delegate: UITableViewDelegate, 
         dataSource: UITableViewDataSource) {
        super.init(frame: .zero)
        layoutView()
        setTableView(delegate, dataSource)
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
    
    private func setTableView(_ delegate: UITableViewDelegate,
                              _ dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    func setTableViewRefreshControl(refreshControl: UIRefreshControl) {
        tableView.refreshControl = refreshControl
    }
    
    func tableViewReloadData() {
        tableView.reloadData()
    }
    
    
}
