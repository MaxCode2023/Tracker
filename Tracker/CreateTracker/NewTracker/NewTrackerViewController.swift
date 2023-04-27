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
    let emojiAndColorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let scheduleViewController = ScheduleViewController()
    let createButton = UIButton()
    let cancelButton = UIButton()
    private var choosedWeekday: [Week]?
    private var choosedEmoji: String?
    private var choosedColor: UIColor?
    
    var selectedIndexPaths: [Int: IndexPath] = [:]
    
    var type: TypeTracker
    var vc: TrackersViewController
    var trackerCategoryStore: TrackerCategoryStore
    
    private let tableNames = ["Категория", "Расписание"]
    
    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    private let colors = [
        #colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1), #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1),
        #colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1),
        #colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1),
    ]
    
    private let params: GeometricParams = GeometricParams(cellCount: 6, leftInset: 12, rightInset: 12, cellSpacing: 5)
    
    init(type: TypeTracker, vc: TrackersViewController, trackerCategoryStore: TrackerCategoryStore) {
        self.type = type
        self.vc = vc
        self.trackerCategoryStore = trackerCategoryStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setUI()
        
        setCollection()
        
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
        
        if choosedEmoji == nil || choosedColor == nil {
            //сюда бы по хорошему алерт выдавать, мол выберите цвет и иконку
            return
        }
        
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
                                                                 color: choosedColor!,
                                                                 emoji: choosedEmoji!,
                                                                 schedule: choosedWeekday ?? [])])
            } else {
                newCategory = TrackerCategory(head: "Новая категория",
                                              trackers: [Tracker(id: 0,
                                                                 name: nameTrackerTextField.text ?? "",
                                                                 color: choosedColor!,
                                                                 emoji: choosedEmoji!,
                                                                 schedule: choosedWeekday ?? [])])
            }
        } else {
            newCategory = TrackerCategory(head: "Новая категория",
                                          trackers: [Tracker(id: UInt(existTrackerCategory!.trackers.count+1),
                                                             name: nameTrackerTextField.text ?? "",
                                                             color: choosedColor!,
                                                             emoji: choosedEmoji!,
                                                             schedule: [.wednesday, .tuesday, .thursday, .sunday, .saturday, .monday, .friday])])
        }
        
        
        
        var updateCategoryList = vc.categories
        updateCategoryList.append(newCategory)
        vc.categories = updateCategoryList
        try! self.trackerCategoryStore.addNewCategory(newCategory)
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

extension NewTrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setCollection() {
        emojiAndColorCollectionView.delegate = self
        emojiAndColorCollectionView.dataSource = self
        emojiAndColorCollectionView.allowsMultipleSelection = false
        emojiAndColorCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiAndColorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        emojiAndColorCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        count = section == 0 ? emojies.count : colors.count
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
        } else if indexPath.section == 1 {
            view.titleLabel.text = "Цвет"
        }
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
        
        var cell: UICollectionViewCell?
        
        if indexPath.section == 0 {
            let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
            emojiCell.emoji.text = emojies[indexPath.row]
            
            if let selectedIndexPath = selectedIndexPaths[indexPath.section], indexPath == selectedIndexPath {
                emojiCell.toggleCell(false)
                choosedEmoji = emojiCell.emoji.text
            } else {
                emojiCell.toggleCell(true)
            }
            cell = emojiCell
            
        } else if indexPath.section == 1 {
            let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
            colorCell.configCell(color: colors[indexPath.row])
            
            if let selectedIndexPath = selectedIndexPaths[indexPath.section], indexPath == selectedIndexPath {
                colorCell.toggleCell(false)
                choosedColor = colorCell.color
            } else {
                colorCell.toggleCell(true)
            }
            cell = colorCell
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedIndexPath = selectedIndexPaths[indexPath.section] {
            selectedIndexPaths[indexPath.section] = nil
            collectionView.reloadItems(at: [selectedIndexPath])
        }
        selectedIndexPaths[indexPath.section] = indexPath
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 49, height: 49)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
}

public enum TypeTracker {
    case habit
    case event
}
