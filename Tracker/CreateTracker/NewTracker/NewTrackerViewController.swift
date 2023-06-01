//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by macOS on 09.04.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController, ScheduleViewControllerDelegate {
    
    let titleLabel = UILabel()
    let nameTrackerTextField = UITextField()
    let settingsTrackerTableView = UITableView()
    let emojiAndColorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let scheduleViewController = ScheduleViewController()
    let createButton = UIButton()
    let cancelButton = UIButton()
    private var choosedWeekday: [Week]?
    
    var type: TypeTracker
    var vc: TrackersViewController
    
    private let tableNames = ["Категория", "Расписание"]
    
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
        cancelButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        
        scheduleViewController.delegate = self
        
        settingsTrackerTableView.delegate = self
        settingsTrackerTableView.dataSource = self
        settingsTrackerTableView.separatorStyle = .singleLine
        settingsTrackerTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        settingsTrackerTableView.register(NewTrackerTableViewCell.self, forCellReuseIdentifier: NewTrackerTableViewCell.reuseIdentifier)
    }
    
    func didFinishPickingWeekDays(weekDayList: [Week]) {
        choosedWeekday = weekDayList
        settingsTrackerTableView.reloadData()
    }
    
    @objc func clickCreate() {
        let existTrackerCategory = vc.categories.first {
            //тут вместо "" надо будет вставить выбранную категорию из таблицы
            $0.head == ""
        }
    
        var newCategory: TrackerCategory
        
        if type == .habit {
            if existTrackerCategory != nil {
                newCategory = TrackerCategory(head: existTrackerCategory!.head,
                                              trackers: [Tracker(id: UInt(existTrackerCategory!.trackers.count+1),
                                                                 name: nameTrackerTextField.text ?? "",
                                                                 color: .green,
                                                                 emoji: "",
                                                                 schedule: choosedWeekday ?? [])])
            } else {
                newCategory = TrackerCategory(head: "Новая категория",
                                              trackers: [Tracker(id: 0,
                                                                 name: nameTrackerTextField.text ?? "",
                                                                 color: .green,
                                                                 emoji: "",
                                                                 schedule: choosedWeekday ?? [])])
            }
        } else {
            newCategory = TrackerCategory(head: existTrackerCategory!.head,
                                          trackers: [Tracker(id: UInt(existTrackerCategory!.trackers.count+1),
                                                             name: nameTrackerTextField.text ?? "",
                                                             color: .green,
                                                             emoji: "",
                                                             schedule: [.wednesday, .tuesday, .thursday, .sunday, .saturday, .monday, .friday])])
        }
        
        var updateCategoryList = vc.categories
        updateCategoryList.append(newCategory)
        vc.categories = updateCategoryList
        
        NotificationCenter.default
            .post(
                name: TrackersViewController.didChangeCollectionNotification,
                object: self,
                userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func clickCancel() {
        dismiss(animated: true)
    }
    
    private func setUI() {
        
        view.backgroundColor = UIColor(named: "white")
        titleLabel.text = "Новая привычка"
        
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(settingsTrackerTableView)
        view.addSubview(emojiAndColorCollectionView)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        
        createButton.backgroundColor = UIColor(named: "grey")
        createButton.layer.cornerRadius = 16
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor(named: "white"), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        cancelButton.backgroundColor = UIColor(named: "white")
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "red")?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.setTitleColor(UIColor(named: "red"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        nameTrackerTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameTrackerTextField.backgroundColor = UIColor(named: "background view")
        nameTrackerTextField.layer.cornerRadius = 16
        nameTrackerTextField.placeholder = "Введите название трекера"
        
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTrackerTextField.frame.height))
        nameTrackerTextField.leftView = textFieldPadding
        nameTrackerTextField.leftViewMode = .always
        nameTrackerTextField.rightView = textFieldPadding
        nameTrackerTextField.rightViewMode = .always
        
        settingsTrackerTableView.layer.cornerRadius = 16
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        settingsTrackerTableView.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            settingsTrackerTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            settingsTrackerTableView.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            settingsTrackerTableView.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            settingsTrackerTableView.heightAnchor.constraint(equalToConstant: type == .habit ? 150 : 75),
            
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

extension NewTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == .habit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = NewTrackerTableViewCell(style: .default, reuseIdentifier: NewTrackerTableViewCell.reuseIdentifier)
        cell.name.text = tableNames[indexPath.row]
        if indexPath.row == 1 {
            var weekString = ""
            if let choosedWeekday = choosedWeekday {
                for i in choosedWeekday.indices {
                    weekString = weekString + (choosedWeekday[i].getShortName()) + ", "
                }
                weekString = String(weekString.dropLast(2))
            }
            cell.choosedParams.text = weekString
        }
        
        cell.backgroundColor = UIColor(named: "background view")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //переход к выбору категории
        } else if indexPath.row == 1 {
            scheduleViewController.modalPresentationStyle = .automatic
            present(scheduleViewController, animated: true)
        }
    }
}

public enum TypeTracker {
    case habit
    case event
}
