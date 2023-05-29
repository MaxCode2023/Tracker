//
//  AnalyticsInteractor.swift
//  Tracker
//
//  Created by macOS on 29.05.2023.
//

import UIKit

protocol AnalyticsService {
    func activate()
    func reportEvent(name: String, event: EventType, screen: UIViewController, item: String?)
}
