//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by macOS on 09.04.2023.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let createHabit = UIButton()
    private let createEvent = UIButton()
    
    var vc: TrackersViewController
    var trackerCategoryStore: TrackerCategoryStore
    
    init(vc: TrackersViewController, trackerCategoryStore: TrackerCategoryStore) {
        self.vc = vc
        self.trackerCategoryStore = trackerCategoryStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUI()
        
        createHabit.addTarget(self, action: #selector(clickHabit), for: .touchUpInside)
        createEvent.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
    }
    
    @objc func clickHabit() {

        let vc = NewTrackerViewController(type: .habit, vc: self.vc, trackerCategoryStore: trackerCategoryStore)
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
    }
    
    @objc func clickEvent() {
        let vc = NewTrackerViewController(type: .event, vc: self.vc, trackerCategoryStore: trackerCategoryStore)
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
    }
    
    private func setUI() {
        view.backgroundColor = UIColor(named: "white")
        
        view.addSubview(titleLabel)
        view.addSubview(createHabit)
        view.addSubview(createEvent)
        
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        createHabit.setTitle("Привычка", for: .normal)
        createEvent.setTitle("Нерегулярное событие", for: .normal)
        createEvent.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createHabit.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createHabit.backgroundColor = UIColor(named: "black")
        createEvent.backgroundColor = UIColor(named: "black")
        createHabit.layer.cornerRadius = 16
        createEvent.layer.cornerRadius = 16
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        createHabit.translatesAutoresizingMaskIntoConstraints = false
        createEvent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            
            createHabit.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            createHabit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createHabit.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabit.heightAnchor.constraint(equalToConstant: 60),
            
            createEvent.topAnchor.constraint(equalTo: createHabit.bottomAnchor, constant: 16),
            createEvent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createEvent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createEvent.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
}
