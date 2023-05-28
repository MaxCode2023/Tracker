//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by macOS on 28.05.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    let titleLabel = UILabel()
    let emptyStatisticsView = UIStackView()
    let emptyStatisticsImage = UIImageView()
    let emptyStatisticsLabel = UILabel()
    let stackView = UIStackView()
    let trackersCompleteView = UIView()
    let trackersCompleteCount = UILabel()
    let trackersCompleteLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        view.addSubview(titleLabel)
        view.addSubview(emptyStatisticsView)
        view.addSubview(stackView)
        emptyStatisticsView.addArrangedSubview(emptyStatisticsImage)
        emptyStatisticsView.addArrangedSubview(emptyStatisticsLabel)
        stackView.addArrangedSubview(trackersCompleteView)
        trackersCompleteView.addSubview(trackersCompleteCount)
        trackersCompleteView.addSubview(trackersCompleteLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsView.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsImage.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteView.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteCount.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            emptyStatisticsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        titleLabel.text = "Статистика"
        emptyStatisticsLabel.text = "Анализировать пока нечего"
        emptyStatisticsImage.image = UIImage(named: "emptyStatistics")
    }
}
