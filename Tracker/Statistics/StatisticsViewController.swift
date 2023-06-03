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
    let trackersCompleteBackgroundView = UIView()
    let trackersCompleteView = UIView()
    let trackersCompleteCount = UILabel()
    let trackersCompleteLabel = UILabel()
    
    let trackerStore = TrackerStore()
    let trackerRecordStore = TrackerRecordStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        try? trackersCompleteCount.text = String(trackerRecordStore.getCompletedTrackersCount())
        
        setGradientOnView(trackersCompleteBackgroundView)
    }
    
    private func setGradientOnView(_ view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.size.width,
                                                            height: view.frame.size.height))
        gradient.colors = [
            UIColor(named: Constants.ColorNames.gradient2)?.cgColor ?? UIColor.green,
            UIColor(named: Constants.ColorNames.gradient3)?.cgColor ?? UIColor.red,
            UIColor(named: Constants.ColorNames.gradient1)?.cgColor ?? UIColor.blue,
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.cornerRadius = 16
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setUI() {
        view.addSubview(titleLabel)
        view.addSubview(emptyStatisticsView)
        view.addSubview(stackView)
        emptyStatisticsView.addArrangedSubview(emptyStatisticsImage)
        emptyStatisticsView.addArrangedSubview(emptyStatisticsLabel)
        stackView.addArrangedSubview(trackersCompleteBackgroundView)
        trackersCompleteBackgroundView.addSubview(trackersCompleteView)
        trackersCompleteView.addSubview(trackersCompleteCount)
        trackersCompleteView.addSubview(trackersCompleteLabel)
        
        activateConstraint()
        
        titleLabel.text = "Статистика"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = UIColor(named: Constants.ColorNames.black)
        
        emptyStatisticsLabel.text = "Анализировать пока нечего"
        emptyStatisticsLabel.textColor = UIColor(named: Constants.ColorNames.black)
        emptyStatisticsLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyStatisticsImage.image = UIImage(named: Constants.ImageNames.emptyStatistics)
        
        if trackerStore.numberOfTrackers == 0 {
            emptyStatisticsView.isHidden = false
            trackersCompleteBackgroundView.isHidden = true
        } else {
            emptyStatisticsView.isHidden = true
            trackersCompleteBackgroundView.isHidden = false
        }

        trackersCompleteView.backgroundColor = UIColor(named: Constants.ColorNames.white)
        trackersCompleteView.layer.cornerRadius = 16
        trackersCompleteBackgroundView.layer.cornerRadius = 16
        
        trackersCompleteCount.textColor = UIColor(named: Constants.ColorNames.black)
        trackersCompleteCount.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        trackersCompleteLabel.text = "Трекеров завершено"
        trackersCompleteLabel.textColor = UIColor(named: Constants.ColorNames.black)
        trackersCompleteLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        emptyStatisticsView.spacing = 8
        emptyStatisticsView.axis = .vertical
        emptyStatisticsView.alignment = .center
    }
    
    private func activateConstraint() {
        setAutolayout()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            emptyStatisticsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackersCompleteBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            trackersCompleteBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCompleteBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackersCompleteView.leadingAnchor.constraint(equalTo: trackersCompleteBackgroundView.leadingAnchor,
                                                          constant: 1),
            trackersCompleteView.trailingAnchor.constraint(equalTo: trackersCompleteBackgroundView.trailingAnchor,
                                                           constant: -1),
            trackersCompleteView.topAnchor.constraint(equalTo: trackersCompleteBackgroundView.topAnchor,
                                                      constant: 1),
            trackersCompleteView.bottomAnchor.constraint(equalTo: trackersCompleteBackgroundView.bottomAnchor,
                                                         constant: -1),
            
            trackersCompleteCount.leadingAnchor.constraint(equalTo: trackersCompleteView.leadingAnchor,
                                                           constant: 12),
            trackersCompleteCount.trailingAnchor.constraint(equalTo: trackersCompleteView.trailingAnchor,
                                                            constant: -12),
            trackersCompleteCount.topAnchor.constraint(equalTo: trackersCompleteView.topAnchor,
                                                       constant: 12),

            trackersCompleteLabel.leadingAnchor.constraint(equalTo: trackersCompleteView.leadingAnchor,
                                                           constant: 12),
            trackersCompleteLabel.topAnchor.constraint(equalTo: trackersCompleteCount.bottomAnchor,
                                                       constant: 7),
            trackersCompleteLabel.bottomAnchor.constraint(equalTo: trackersCompleteView.bottomAnchor,
                                                          constant: -12),
            trackersCompleteLabel.trailingAnchor.constraint(equalTo: trackersCompleteView.trailingAnchor,
                                                            constant: -12),
            
            emptyStatisticsImage.widthAnchor.constraint(equalToConstant: 80),
            emptyStatisticsImage.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func setAutolayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsView.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsImage.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteView.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteCount.translatesAutoresizingMaskIntoConstraints = false
        trackersCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
