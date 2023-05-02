//
//  ButtonExtension.swift
//  Tracker
//
//  Created by macOS on 02.05.2023.
//

import UIKit

extension UIButton {
    func blockedButton() {
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(named: "grey")
    }
    
    func unblockedButton() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor(named: "black")
    }
}
