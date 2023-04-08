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
    private let searchTextField = UISearchTextField()
    private let emptyTrackersView = UIStackView()
    private let emptyTrackersImageView = UIImageView()
    private let emptyTrackersLabel = UILabel()
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollection()
        
    }
    
    private func setUI() {
        view.addSubview(trackersLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTextField)
        view.addSubview(trackersCollectionView)
        view.addSubview(emptyTrackersView)
        emptyTrackersView.addArrangedSubview(emptyTrackersImageView)
        emptyTrackersView.addArrangedSubview(emptyTrackersLabel)
                
        trackersLabel.text = "Трекеры"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Поиск"
        emptyTrackersImageView.image = UIImage(named: "emptyTrackers")
        emptyTrackersLabel.text = "Что будем отслеживать?"
        emptyTrackersView.axis = .vertical
        emptyTrackersView.alignment = .center
        emptyTrackersView.spacing = 8
        emptyTrackersView.isHidden = true
        searchTextField.layer.cornerRadius = 10

        let addButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = addButton
        addButton.tintColor = UIColor(named: "black")
        
        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: trackersLabel.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: trackersLabel.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 11),
            emptyTrackersView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackersView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func addButtonTapped() {
        print("addButtonTapped")
    }

}

extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCollection() {
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    
}
