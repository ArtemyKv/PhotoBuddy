//
//  RoundButton.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
