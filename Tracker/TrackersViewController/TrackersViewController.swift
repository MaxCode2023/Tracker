//
//  ViewController.swift
//  Tracker
//
//  Created by macOS on 25.03.2023.
//

import UIKit
import Foundation

final class TrackersViewController: UIViewController {
    
    

    private let datePicker = UIDatePicker()
    private let trackersLabel = UILabel()
    private let searchTrackersBar = UISearchBar()
    private let emptyTrackersView = UIStackView()
    private let emptyTrackersImageView = UIImageView()
    private let emptyTrackersLabel = UILabel()
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    public var categories: [TrackerCategory] = [TrackerCategory]()
    private var visibleCategories: [TrackerCategory] = [TrackerCategory]()
    public var completedTrackers: [TrackerRecord] = [TrackerRecord]()
    private var currentDate: Date = Date()
    
    private let params: GeometricParams = GeometricParams(cellCount: 2, leftInset: 12, rightInset: 12, cellSpacing: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories.append(TrackerCategory(head: "testovy", trackers:
                                            [Tracker(id: 0, name: "test", color: .orange, emoji: "", schedule: [.friday]),
                                             Tracker(id: 1, name: "privet", color: .blue, emoji: "", schedule: [.friday])]
                                         ))
        categories.append(TrackerCategory(head: "testovy2", trackers:
                                            [Tracker(id: 3, name: "test", color: .green, emoji: "", schedule: [.friday])]
                                                           ))
        categories.append(TrackerCategory(head: "testovy3", trackers:
                                            [Tracker(id: 3, name: "test", color: .gray, emoji: "", schedule: [.friday])]
                                                           ))
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        searchTrackersBar.delegate = self
        setUI()
        setVisibleCategories()
        setCollection()
        
        checkCategories()
    }
    
    private func checkCategories() {
        if visibleCategories.isEmpty {
            emptyTrackersView.isHidden = false
        } else {
            emptyTrackersView.isHidden = true
        }
    }
    
    private func setUI() {
        view.addSubview(trackersLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTrackersBar)
        view.addSubview(trackersCollectionView)
        view.addSubview(emptyTrackersView)
        emptyTrackersView.addArrangedSubview(emptyTrackersImageView)
        emptyTrackersView.addArrangedSubview(emptyTrackersLabel)
                
        trackersLabel.text = "Трекеры"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        searchTrackersBar.placeholder = "Поиск"
        emptyTrackersImageView.image = UIImage(named: "emptyTrackers")
        emptyTrackersLabel.text = "Что будем отслеживать?"
        emptyTrackersView.axis = .vertical
        emptyTrackersView.alignment = .center
        emptyTrackersView.spacing = 8
        emptyTrackersView.isHidden = true
        searchTrackersBar.layer.cornerRadius = 10

        let addButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = addButton
        addButton.tintColor = UIColor(named: "black")
        
        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        searchTrackersBar.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: trackersLabel.centerYAnchor),
            searchTrackersBar.leadingAnchor.constraint(equalTo: trackersLabel.leadingAnchor),
            searchTrackersBar.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            searchTrackersBar.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 11),
            emptyTrackersView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackersView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTrackersBar.bottomAnchor, constant: 34),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setVisibleCategories() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        

        
        visibleCategories = categories.filter { trackerCategory in
            trackerCategory.trackers.contains { tracker in
                tracker.schedule.contains { week in
                    week.rawValue == weekday
                }
            }
        }
        
//        visibleCategories = filteredCategories
//        filteredVisibleCategories = visibleCategories
        checkCategories()
        trackersCollectionView.reloadData()
    }
    
    @objc func addButtonTapped() {
        let vc = CreateTrackerViewController(vc: self)
        vc.title = "Создание трекера"
        present(vc, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = datePicker.date
        setVisibleCategories()
    }
}

extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setCollection() {
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        trackersCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let indexPath = IndexPath(row: 0, section: section)
        return visibleCategories[indexPath.section].trackers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        view.titleLabel.text = visibleCategories[indexPath.section].head
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell
        cell?.color = visibleCategories[indexPath.section].trackers[indexPath.row].color
        cell?.title.text = visibleCategories[indexPath.section].trackers[indexPath.row].name
        cell?.id = visibleCategories[indexPath.section].trackers[indexPath.row].id
        cell?.delegate = self
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

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let data = visibleCategories
        if searchText.isEmpty || searchText == " " {
            setVisibleCategories()
        } else {
            
            visibleCategories = visibleCategories.filter({ trackersCategory in
                let filteredTrackers = trackersCategory.trackers.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
                return !filteredTrackers.isEmpty
            }).map { category in
                TrackerCategory(head: category.head, trackers: category.trackers.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil })
            }
        }

        trackersCollectionView.reloadData()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func appendToCompletedCategories(id: UInt) {
        completedTrackers.append(TrackerRecord(id: id, date: datePicker.date))
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
