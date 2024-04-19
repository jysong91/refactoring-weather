//
//  Util.swift
//  WeatherForecast
//
//  Created by Hong yujin on 4/19/24.
//

import UIKit

final class Util {
    static func showAlert(viewController: UIViewController?,
                   title: String,
                   message: String,
                   buttonTitle: String,
                   handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController: UIAlertController = UIAlertController(title: title,
                                                                   message: message,
                                                                   preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(defaultAction)
        viewController?.present(alertController, animated: true)
    }
}

