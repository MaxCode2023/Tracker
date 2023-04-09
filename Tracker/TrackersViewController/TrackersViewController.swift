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
    
    public var categories: [TrackerCategory] = [TrackerCategory]()
    private var visibleCategories: [TrackerCategory] = [TrackerCategory]()
    private var completedTrackers: [TrackerRecord] = [TrackerRecord]()
    private var currentDate: Date = Date()
    
    private let params: GeometricParams = GeometricParams(cellCount: 2, leftInset: 12, rightInset: 12, cellSpacing: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories.append(TrackerCategory(head: "", trackers:
                                            [Tracker(id: 0, name: "test", color: .orange, emoji: "", schedule: [.friday]),
                                             Tracker(id: 1, name: "privet", color: .blue, emoji: "", schedule: [.friday])]
                                         ))
        
        setUI()
        setCollection()
        
        checkCategories()
    }
    
    private func checkCategories() {
        if categories.isEmpty && visibleCategories.isEmpty {
            emptyTrackersView.isHidden = false
        } else {
            emptyTrackersView.isHidden = true
        }
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
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func addButtonTapped() {
        print("CATEGORIES: \(categories)")
        let vc = CreateTrackerViewController(vc: self)
        vc.title = "Создание трекера"
        present(vc, animated: true)
    }

}

extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setCollection() {
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell
        cell?.color = categories[0].trackers[indexPath.row].color
        cell?.title.text = categories[0].trackers[indexPath.row].name
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
}

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
