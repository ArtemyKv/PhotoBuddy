//
//  AlertPresenter.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 28.11.2022.
//

import UIKit

protocol AlertPresenter: UIViewController { }

extension AlertPresenter {
    func presentErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    func presentAuthorizationStatusAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let goToSettingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL) { success in
                    print("Settings opened: \(success)")
                }
            }
        }
        alertController.addAction(goToSettingsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}



