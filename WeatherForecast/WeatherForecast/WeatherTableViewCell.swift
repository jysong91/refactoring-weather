//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherTableViewCell: UITableViewCell {
    var weatherIcon: UIImageView = UIImageView()
    var dateLabel: UILabel = UILabel()
    var temperatureLabel: UILabel = UILabel()
    var weatherLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var dashLabel: UILabel = UILabel()
    var weatherStackView: UIStackView?
    var verticalStackView: UIStackView?
    var contentsStackView: UIStackView?
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layViews()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func layViews() {
        layLabels()
        setWeatherStackView()
        setVerticalStackView()
        setContentsStackView()
        layContentsStackView()
    }
    
    private func layLabels() {
        let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, dashLabel, descriptionLabel]
        
        labels.forEach { label in
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 1
        }
    }
    
    private func setWeatherStackView() {
        weatherStackView = UIStackView(arrangedSubviews: [
            weatherLabel,
            dashLabel,
            descriptionLabel
        ])
        
        descriptionLabel.setContentHuggingPriority(.defaultLow,
                                                   for: .horizontal)
        
        weatherStackView?.axis = .horizontal
        weatherStackView?.spacing = 8
        weatherStackView?.alignment = .center
        weatherStackView?.distribution = .fill
    }
    
    private func setVerticalStackView() {
        guard let weatherStackView = weatherStackView else { return }
        
        verticalStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            temperatureLabel,
            weatherStackView
        ])
        
        verticalStackView?.axis = .vertical
        verticalStackView?.spacing = 8
        verticalStackView?.distribution = .fill
        verticalStackView?.alignment = .leading
    }
    
    private func setContentsStackView() {
        guard let verticalStackView = verticalStackView else { return }
        
        contentsStackView = UIStackView(arrangedSubviews: [
            weatherIcon,
            verticalStackView
        ])
               
        if let contentsStackView = contentsStackView {
            contentsStackView.axis = .horizontal
            contentsStackView.spacing = 16
            contentsStackView.alignment = .center
            contentsStackView.distribution = .fill
            contentsStackView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(contentsStackView)
        }
    }
    
    private func layContentsStackView() {
        guard let contentsStackView = contentsStackView else { return }
        
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func reset() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
    }
}
