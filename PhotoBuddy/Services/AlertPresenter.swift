//
//  AlertPresenter.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 28.11.2022.
//

import UIKit

protocol AlertPresenter: UIViewController { }

extension AlertPresenter {
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}



