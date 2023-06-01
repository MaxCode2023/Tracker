//
//  TabBarController.swift
//  Tracker
//
//  Created by macOS on 02.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.backgroundColor = .white
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Трекеры", comment: ""),
            image: UIImage(named: "trackers icon"),
            selectedImage: nil)
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController()) 
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Статистика", comment: ""),
            image: UIImage(named: "statistic icon"),
            selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }

}
