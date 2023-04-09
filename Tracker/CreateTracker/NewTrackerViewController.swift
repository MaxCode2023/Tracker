//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by macOS on 09.04.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    
    let titleView = UILabel()
    let nameTrackerTextField = UITextField()
    let settingsTrackerTableView = UITableView()
    let emojiAndColorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let createButton = UIButton()
    let cancelButton = UIButton()
    
    var type: TypeTracker
    var vc: TrackersViewController
    
    init(type: TypeTracker, vc: TrackersViewController) {
        self.type = type
        self.vc = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        setUI()
        
        if type == .habit {
            //тут надо сделать вкладку "расписание" в таблице
        } else if type == .event {
            //таблица без расписания
        } else {
            
        }
        
        createButton.addTarget(self, action: #selector(clickCreate), for: .touchUpInside)
    }
    
    @objc func clickCreate() {
        let newCategory = TrackerCategory(head: "", trackers: [Tracker(id: 2, name: nameTrackerTextField.text ?? "", color: .green, emoji: "", schedule: [.friday])])
        var updateCategoryList = vc.categories
        updateCategoryList.append(newCategory)
        
        vc.categories = updateCategoryList
        dismiss(animated: true)
    }
    
    private func setUI() {
        
        view.backgroundColor = UIColor(named: "white")
        titleView.text = "Новая привычка"
        
        view.addSubview(titleView)
        view.addSubview(nameTrackerTextField)
        view.addSubview(settingsTrackerTableView)
        view.addSubview(emojiAndColorCollectionView)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        
        createButton.backgroundColor = UIColor(named: "grey")
        createButton.layer.cornerRadius = 16
        createButton.setTitle("Создать", for: .normal)
        createButton.tintColor = UIColor(named: "white")
        
        cancelButton.backgroundColor = UIColor(named: "white")
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "red")?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.tintColor = UIColor(named: "red")
        nameTrackerTextField.backgroundColor = UIColor(named: "background view")
        nameTrackerTextField.layer.cornerRadius = 16
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        settingsTrackerTableView.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 38),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            settingsTrackerTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            settingsTrackerTableView.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            settingsTrackerTableView.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            
            emojiAndColorCollectionView.topAnchor.constraint(equalTo: settingsTrackerTableView.bottomAnchor, constant: 32),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 46),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            createButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 46),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
            
        ])
        
        
    }
    
}

public enum TypeTracker {
    case habit
    case event
}
