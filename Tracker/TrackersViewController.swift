//
//  ViewController.swift
//  Tracker
//
//  Created by macOS on 25.03.2023.
//

import UIKit

final class TrackersViewController: UIViewController {

    private let datePicker = UIDatePicker()
    private let trackersLabel = UILabel()
    private let searchTextField = UITextField()
    private let emptyTrackersView = UIView()
    private let emptyTrackersImageView = UIImageView()
    private let emptyTrackersLabel = UILabel()
    private let trackersCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        
    }
    
    private func setUI() {
        view.addSubview(trackersLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTextField)
        view.addSubview(emptyTrackersView)
        view.addSubview(emptyTrackersLabel)
        emptyTrackersView.addSubview(emptyTrackersImageView)
        
        trackersLabel.text = "Трекеры"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Поиск"
        emptyTrackersImageView.image = UIImage(named: "emptyTrackers")
        emptyTrackersLabel.text = "Что будем отслеживать?"
        
        let searchImageView = UIImageView(frame: CGRect(x: 8, y: 0, width: 15, height: 15))
        searchImageView.image = UIImage(named: "search")
        searchImageView.contentMode = .scaleAspectFill
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: searchImageView.frame.width + 8, height: searchImageView.frame.height))
        paddingView.addSubview(searchImageView)
        paddingView.contentMode = .scaleToFill
        searchTextField.leftViewMode = .always
        searchTextField.leftView = paddingView
        searchTextField.layer.cornerRadius = 10
        
        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: trackersLabel.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: trackersLabel.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 11),
            emptyTrackersView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackersView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyTrackersImageView.centerXAnchor.constraint(equalTo: emptyTrackersView.centerXAnchor),
            emptyTrackersImageView.centerYAnchor.constraint(equalTo: emptyTrackersView.centerYAnchor),
            emptyTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImageView.bottomAnchor, constant: 8),
            
        ])
    }
}

