//
//  ImageCachable.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/23/24.
//

import UIKit

protocol ImageCachable {
    func value(for key: String) -> UIImage?
    func store(for key: String, image: UIImage)
}
