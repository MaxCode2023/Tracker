//
//  ViewController.swift
//  Tracker
//
//  Created by macOS on 25.03.2023.
//

import UIKit
import YandexMobileMetrica

final class TrackersViewController: UIViewController, TrackerRecordStoreDelegate, TrackerStoreDelegate {
    func didUpdate() {
        checkTrackers()
        trackersCollectionView.reloadData()
    }
    
    func didUpdateRecords(_ records: Set<TrackerRecord>) {
        completedTrackers = records
    }
    
    private let datePicker = UIDatePicker()
    private let trackersLabel = UILabel()
    private let searchTrackersBar = UISearchBar()
    private let emptyTrackersView = UIStackView()
    private let emptyTrackersImageView = UIImageView()
    private let emptyTrackersLabel = UILabel()
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var completedTrackers: Set<TrackerRecord> = []
    private var completedTrackerIds = Set<UInt>()

    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsServiceImpl()

    private var currentDate = Calendar.current.startOfDay(for: Date())
    
    static let didChangeCollectionNotification = Notification.Name(rawValue: "TrackersCollectionDidChange")
    private var trackersCollectionObserver: NSObjectProtocol?
    
    private let params: GeometricParams = GeometricParams(cellCount: 2, leftInset: 12, rightInset: 12, cellSpacing: 9)
    
    private var searchText = "" {
        didSet {
            try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUI()
        setCollection()

        addObserverForCollection()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        searchTrackersBar.delegate = self
        
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        
        try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        try? trackerRecordStore.loadCompletedTrackers(by: currentDate)
        
        checkTrackers()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        searchTrackersBar.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        analyticsService.reportEvent(name: "OpenMainScreen", event: .open, screen: self, item: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        analyticsService.reportEvent(name: "CloseMainScreen", event: .close, screen: self, item: nil)
    }
    
    private func checkTrackers() {
        if trackerStore.numberOfTrackers == 0 {
            emptyTrackersView.isHidden = false
            trackersCollectionView.isHidden = true
        } else {
            emptyTrackersView.isHidden = true
            trackersCollectionView.isHidden = false
        }
    }
    
    private func addObserverForCollection() {
        trackersCollectionObserver = NotificationCenter.default
            .addObserver(
                forName: TrackersViewController.didChangeCollectionNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.checkTrackers()
                self.trackersCollectionView.reloadData()
            }
    }
    
    @objc private func addButtonTapped() {
        analyticsService.reportEvent(name: "AddTrackerTap", event: .click, screen: self, item: "add_track")

        let vc = CreateTrackerViewController(vc: self, trackerCategoryStore: trackerCategoryStore)
        vc.title = "Создание трекера"
        present(vc, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = Calendar.current.startOfDay(for: datePicker.date)
        do {
            try trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
            try trackerRecordStore.loadCompletedTrackers(by: currentDate)
        } catch {}
        trackersCollectionView.reloadData()
    }
    
    func findLabelsInDatePicker(view: UIView) -> [UILabel] {
        var labels: [UILabel] = []
        for subview in view.subviews {
            if let label = subview as? UILabel {
                labels.append(label)
            } else {
                labels += findLabelsInDatePicker(view: subview)
            }
        }
        return labels
    }

    private func setUI() {
        view.addSubview(trackersLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTrackersBar)
        view.addSubview(trackersCollectionView)
        view.addSubview(emptyTrackersView)
        emptyTrackersView.addArrangedSubview(emptyTrackersImageView)
        emptyTrackersView.addArrangedSubview(emptyTrackersLabel)
                
        trackersLabel.text = NSLocalizedString("trackers", comment: "")
        trackersLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackersLabel.textColor = UIColor(named: "black")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        emptyTrackersImageView.image = UIImage(named: "emptyTrackers")
        emptyTrackersLabel.text = "Что будем отслеживать?"
        emptyTrackersLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyTrackersLabel.textColor = UIColor(named: "black")
        emptyTrackersView.axis = .vertical
        emptyTrackersView.alignment = .center
        emptyTrackersView.spacing = 8
        emptyTrackersView.isHidden = true
        searchTrackersBar.layer.cornerRadius = 10
        searchTrackersBar.searchBarStyle = .minimal
        searchTrackersBar.placeholder = "Поиск"
        searchTrackersBar.tintColor = UIColor(named: "datePicker background")
        trackersCollectionView.backgroundColor = UIColor(named: "white")
        
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        if let datePickerView = datePicker.subviews.first {
            let labels = findLabelsInDatePicker(view: datePickerView)
            for label in labels {
                label.textColor = UIColor(named: "always black")
            }
        }
        datePicker.backgroundColor = UIColor(named: "datePicker background")

        view.backgroundColor = UIColor(named: "white")

        let addButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
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
}

extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setCollection() {
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        trackersCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        view.titleLabel.text = trackerStore.headerLabelInSection(indexPath.section)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell,
              let tracker = trackerStore.tracker(at: indexPath)
        else {return TrackerCollectionViewCell()}
        
        let isCompleted = completedTrackers.contains {
            $0.trackerId == tracker.id && $0.date == currentDate
        }
        
        cell.configCell(tracker: tracker, count: tracker.completedDaysCount, isCompleted: isCompleted)
        cell.delegate = self
        return cell
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
        self.searchText = searchText
        trackersCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func didAttachTracker(cell: TrackerCollectionViewCell) {
        guard let indexPath = self.trackersCollectionView.indexPath(for: cell) else { return }
        if let tracker = try? trackerStore.getTrackerCoreData(by: indexPath) {
            trackerCategoryStore.attachTracker(tracker: tracker)
        }
    }
    
    func didUnattachTracker(cell: TrackerCollectionViewCell) {
        guard let indexPath = self.trackersCollectionView.indexPath(for: cell) else { return }
        if let tracker = try? trackerStore.getTrackerCoreData(by: indexPath) {
            trackerCategoryStore.unattachTracker(tracker: tracker)
        }
    }
    
    func didDeleteTracker(tracker: Tracker) {
        analyticsService.reportEvent(name: "DeleteTracker", event: .click, screen: self, item: "delete")
        showAlert {
            
            if let allCompletedTrackers = try? self.trackerRecordStore.getAllCompletedTrackers() {
                for _ in allCompletedTrackers {
                    if let removedRecord = self.completedTrackers.first(where: { $0.trackerId == tracker.id }) {
                        try? self.trackerRecordStore.remove(removedRecord)
                    }
                }
            }
            try? self.trackerStore.deleteTracker(tracker)
        }
    }
    
    func didEditTracker(cell: TrackerCollectionViewCell) {
        analyticsService.reportEvent(name: "EditTracker", event: .click, screen: self, item: "edit")
        guard let indexPath = self.trackersCollectionView.indexPath(for: cell) else { return }
        if let tracker = try? self.trackerStore.tracker(at: indexPath),
           let trackerCoreData = try? self.trackerStore.getTrackerCoreData(by: indexPath) {
            
            let trackerCategory = try? self.trackerCategoryStore.actualCategory(tracker: trackerCoreData)
            
            let typeTracker: TypeTracker = tracker.schedule == Week.allCases ? .event : .habit
            let vc = NewTrackerViewController(type: typeTracker, tracker, trackerCategory, completedTrackers, currentDate)
            present(vc, animated: true)
        }
    }
    
    func clickDoneButton(cell: TrackerCollectionViewCell, tracker: Tracker) {
        if currentDate <= Calendar.current.startOfDay(for: Date()) {
            if let a = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
                try? trackerRecordStore.remove(a)
                cell.toggleDoneButton(false)
                cell.decreaseCount()
            } else {
                let trackerRecord = TrackerRecord(id: UUID(), trackerId: tracker.id, date: currentDate)
                try? trackerRecordStore.addRecord(trackerRecord)
                cell.toggleDoneButton(true)
                cell.increaseCount()
            }
            analyticsService.reportEvent(name: "TapOnTracker", event: .click, screen: self, item: "track")
        }
    }
    
    private func showAlert(onCompletion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: "Уверены, что хотите удалить трекер?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            onCompletion()
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

public struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    public init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
