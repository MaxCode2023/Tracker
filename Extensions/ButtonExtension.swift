//
//  ButtonExtension.swift
//  Tracker
//
//  Created by macOS on 16.04.2023.
//

import UIKit

extension UIButton {
    func blockedButton() {
        self.isUserInteractionEnabled = false
    }
    
    func unblockedButton() {
        self.isUserInteractionEnabled = true
    }
}
