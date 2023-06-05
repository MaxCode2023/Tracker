//
//  AnalyticsInteractorImpl.swift
//  Tracker
//
//  Created by macOS on 29.05.2023.
//

import UIKit
import YandexMobileMetrica

class AnalyticsServiceImpl: AnalyticsService {
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "68692d79-b306-4680-b84f-ca4983adf9e0") else {
            return
        }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func reportEvent(name: String, event: EventType, screen: ScreenName, item: String?) {
        let params : [AnyHashable : Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue,
            "item": item ?? "none"]
        YMMYandexMetrica.reportEvent(name, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
