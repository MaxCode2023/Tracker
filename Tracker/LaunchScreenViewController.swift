//
//  LaunchScreen.swift
//  Tracker
//
//  Created by macOS on 02.04.2023.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    private let image = UIImageView(image: UIImage(named: "Logo"))
    private let tabBarViewControllerIdentifier = "TabBarViewController"
    
    override func viewDidLoad() {
        setUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let defaults = UserDefaults.standard
            if !defaults.bool(forKey: "isFirstLaunch") {
                defaults.set(true, forKey: "isFirstLaunch")
                guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
                let onboardingViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                window.rootViewController = onboardingViewController
            } else {
                self?.setTabBarController()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    
    private func setUI() {
        view.backgroundColor = UIColor(named: "blue")
        
        view.addSubview(image)
        image.center = view.center
    }
    
    private func setTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarViewControllerIdentifier)
        window.rootViewController = tabBarController
    }
}
