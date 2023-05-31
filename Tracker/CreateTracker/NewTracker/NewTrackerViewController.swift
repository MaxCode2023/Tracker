//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by macOS on 09.04.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController, UITextFieldDelegate, ScheduleViewControllerDelegate, ChooseCategoryViewControllerDelegate, TrackerRecordStoreDelegate {
    
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    
    private let editTrackerView = UIStackView()
    private let editTrackerCountLabel = UILabel()
    private let editTrackerPlusButton = UIView()
    private let editTrackerMinusButton = UIView()
    private let editTrackerPlusLabel = UILabel()
    private let editTrackerMinusLabel = UILabel()
    
    private let nameTrackerTextField = UITextField()
    private let settingsTrackerTableView = UITableView()
    private let emojiAndColorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var scheduleViewController = ScheduleViewController()
    private let createButton = UIButton()
    private let cancelButton = UIButton()
    private var choosedWeekday: [Week]?
    private var choosedCategory: TrackerCategory?
    private var choosedEmoji: String?
    private var choosedColor: UIColor?
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    var selectedIndexPaths: [Int: IndexPath] = [:]
    
    var type: TypeTracker
    private var editableTracker: Tracker? = nil
    private var editableTrackerCategory: TrackerCategory? = nil
    private var countDays: Int?
    private let daysLabel = NSLocalizedString("days", comment: "")
    private var completedTrackers: Set<TrackerRecord>? = nil
    
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
    
    init(type: TypeTracker, _ editableTracker: Tracker? = nil, _ editableTrackerCategory: TrackerCategory? = nil, _ completedTrackers: Set<TrackerRecord>? = nil) {
        self.type = type
        self.editableTracker = editableTracker
        self.editableTrackerCategory = editableTrackerCategory
        self.completedTrackers = completedTrackers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setUI()
        
        setCollection()
        
        createButton.addTarget(self, action: #selector(clickCreate), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        nameTrackerTextField.addTarget(self, action: #selector(nameDidChanged), for: .editingChanged)
        let tapMinusButton = UITapGestureRecognizer(target: self, action: #selector(clickMinusButton))
        editTrackerMinusButton.addGestureRecognizer(tapMinusButton)
        let tapPlusButton = UITapGestureRecognizer(target: self, action: #selector(clickPlusButton))
        editTrackerPlusButton.addGestureRecognizer(tapPlusButton)
        
        scheduleViewController.delegate = self
        trackerRecordStore.delegate = self
        
        settingsTrackerTableView.delegate = self
        settingsTrackerTableView.dataSource = self
        settingsTrackerTableView.separatorStyle = .singleLine
        settingsTrackerTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        settingsTrackerTableView.register(NewTrackerTableViewCell.self, forCellReuseIdentifier: NewTrackerTableViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if editableTracker != nil {
            setEmojiAndColor()
        }
    }
    
    @objc private func nameDidChanged() {
        checkUnblockedButton()
    }
    
    func didUpdateRecords(_ records: Set<TrackerRecord>) {
        self.completedTrackers = records
    }
    
    func checkUnblockedButton() {
        
        let checkForEvent = choosedEmoji == nil || choosedColor == nil || nameTrackerTextField.text?.isEmpty ?? true || nameTrackerTextField.text == " " || choosedCategory == nil
        let checkForHabit = checkForEvent || choosedWeekday == nil
        
        if type == .event {
            if checkForEvent {
                createButton.blockedButton()
            } else {
                createButton.unblockedButton()
            }
        } else if type == .habit {
            if checkForHabit {
                createButton.blockedButton()
            } else {
                createButton.unblockedButton()
            }
        }
    }
    
    func didFinishPickingWeekDays(weekDayList: [Week]) {
        choosedWeekday = weekDayList
        settingsTrackerTableView.reloadData()
        checkUnblockedButton()
    }
    
    func didConfirmCategory(category: TrackerCategory) {
        choosedCategory = category
        settingsTrackerTableView.reloadData()
        dismiss(animated: true)
        checkUnblockedButton()
    }
    
    @objc private func clickCreate() {
        guard let choosedColor = choosedColor,
              let choosedEmoji = choosedEmoji,
              let choosedCategory = choosedCategory else {return}
        
        if editableTracker == nil {
            
            var newTracker: Tracker
            
            if type == .habit {
                guard let choosedWeekday = choosedWeekday else {return}
                
                newTracker = Tracker(id: UUID(),
                                     name: nameTrackerTextField.text ?? "",
                                     color: choosedColor,
                                     emoji: choosedEmoji,
                                     completedDaysCount: 0,
                                     schedule: choosedWeekday,
                                     isAttached: false)
            } else {
                newTracker = Tracker(id: UUID(),
                                     name: nameTrackerTextField.text ?? "",
                                     color: choosedColor,
                                     emoji: choosedEmoji,
                                     completedDaysCount: 0,
                                     schedule: Week.allCases,
                                     isAttached: false)
            }

            try? trackerStore.addTracker(newTracker, with: choosedCategory)
        } else {
            if let editableTracker = editableTracker {
                let newTracker = Tracker(id: editableTracker.id,
                                         name: nameTrackerTextField.text ?? "",
                                         color: choosedColor,
                                         emoji: choosedEmoji,
                                         completedDaysCount: countDays ?? 0,
                                         schedule: choosedWeekday,
                                         isAttached: false)
                try? trackerStore.editTracker(oldTracker: editableTracker, newTracker: newTracker, category: choosedCategory)
            }
        }
        
        NotificationCenter.default
            .post(
                name: TrackersViewController.didChangeCollectionNotification,
                object: self,
                userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc private func clickCancel() {
        dismiss(animated: true)
    }
    
    @objc private func clickMinusButton() {
        if var count = countDays {
            if count > 0 {
                count = count - 1
            }
            countDays = count
            editTrackerCountLabel.text = "\(String(describing: countDays ?? 0)) \(daysLabel)"
        }
        
        if let a = completedTrackers?.first(where: { $0.trackerId == editableTracker?.id }) {
            try? trackerRecordStore.remove(a)
        }
    }
    
    @objc private func clickPlusButton() {
        if var count = countDays {
            if count >= 0 {
                count = count + 1
            }
            countDays = count
            editTrackerCountLabel.text = "\(String(describing: countDays ?? 0)) \(daysLabel)"
        }
        let trackerRecord = TrackerRecord(id: UUID(), trackerId: editableTracker?.id ?? UUID(), date: Calendar.current.startOfDay(for: Date()))
        try? trackerRecordStore.addRecord(trackerRecord)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkUnblockedButton()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkUnblockedButton()
    }
    
    private func setUI() {
        view.backgroundColor = UIColor(named: "white")
        
        view.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(editTrackerView)
       
        titleStackView.axis = .vertical
        titleStackView.spacing = 24
        titleStackView.alignment = .center
        
        if editableTracker != nil && editableTrackerCategory != nil {
            titleLabel.text = "Редактирование привычки"
            editTrackerView.isHidden = false
            createButton.setTitle("Сохранить", for: .normal)
            nameTrackerTextField.text = editableTracker?.name
            choosedWeekday = editableTracker?.schedule
            choosedColor = editableTracker?.color
            choosedEmoji = editableTracker?.emoji
            countDays = editableTracker?.completedDaysCount
            editTrackerCountLabel.text = "\(String(describing: countDays ?? 0)) \(daysLabel)"
            didConfirmCategory(category: editableTrackerCategory!)
            self.scheduleViewController = ScheduleViewController(choosedWeekdays: editableTracker?.schedule)
        } else {
            titleLabel.text = "Новая привычка"
            editTrackerView.isHidden = true
            createButton.setTitle("Создать", for: .normal)
        }
        
        view.addSubview(nameTrackerTextField)
        view.addSubview(settingsTrackerTableView)
        view.addSubview(emojiAndColorCollectionView)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        editTrackerView.addArrangedSubview(editTrackerMinusButton)
        editTrackerView.addArrangedSubview(editTrackerCountLabel)
        editTrackerView.addArrangedSubview(editTrackerPlusButton)
        editTrackerMinusButton.addSubview(editTrackerMinusLabel)
        editTrackerPlusButton.addSubview(editTrackerPlusLabel)
        
        createButton.backgroundColor = UIColor(named: "grey")
        createButton.layer.cornerRadius = 16
        
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
        
        editTrackerView.axis = .horizontal
        editTrackerView.spacing = 24
        editTrackerView.alignment = .center
        
        editTrackerMinusButton.backgroundColor = UIColor(named: "collection orange")
        editTrackerMinusButton.layer.cornerRadius = 17
        editTrackerMinusLabel.text = "-"
        editTrackerMinusLabel.textColor = UIColor(named: "always white")
        editTrackerMinusLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        editTrackerPlusButton.backgroundColor = UIColor(named: "collection orange")
        editTrackerPlusButton.layer.cornerRadius = 17
        editTrackerPlusLabel.text = "+"
        editTrackerPlusLabel.textColor = UIColor(named: "always white")
        editTrackerPlusLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        editTrackerCountLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)

        nameTrackerTextField.delegate = self
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        editTrackerView.translatesAutoresizingMaskIntoConstraints = false
        editTrackerMinusButton.translatesAutoresizingMaskIntoConstraints = false
        editTrackerPlusButton.translatesAutoresizingMaskIntoConstraints = false
        editTrackerMinusLabel.translatesAutoresizingMaskIntoConstraints = false
        editTrackerPlusLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        settingsTrackerTableView.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleStackView.bottomAnchor.constraint(equalTo: nameTrackerTextField.topAnchor, constant: -40),

            nameTrackerTextField.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 38),
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
            
            editTrackerMinusButton.heightAnchor.constraint(equalToConstant: 34),
            editTrackerMinusButton.widthAnchor.constraint(equalToConstant: 34),
            editTrackerMinusLabel.centerXAnchor.constraint(equalTo: editTrackerMinusButton.centerXAnchor),
            editTrackerMinusLabel.centerYAnchor.constraint(equalTo: editTrackerMinusButton.centerYAnchor),
            
            editTrackerPlusButton.heightAnchor.constraint(equalToConstant: 34),
            editTrackerPlusButton.widthAnchor.constraint(equalToConstant: 34),
            editTrackerPlusLabel.centerXAnchor.constraint(equalTo: editTrackerPlusButton.centerXAnchor),
            editTrackerPlusLabel.centerYAnchor.constraint(equalTo: editTrackerPlusButton.centerYAnchor),
            
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
    
    func setEmojiAndColor() {
        
        for (index, _) in emojies.enumerated() {
            
            if emojies[index] == editableTracker?.emoji {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndexPaths[indexPath.section] = indexPath
                emojiAndColorCollectionView.reloadItems(at: [indexPath])
            }
        }
        
        for (index, color) in colors.enumerated() {
            
            if compareColors(color1: color, color2: editableTracker?.color ?? .blue) {
                let indexPath = IndexPath(row: index, section: 1)
                selectedIndexPaths[indexPath.section] = indexPath
                emojiAndColorCollectionView.reloadItems(at: [indexPath])
            }
        }
        
        checkUnblockedButton()
    }
    
    func compareColors (color1: UIColor, color2: UIColor) -> Bool {
        var red: CGFloat = 0
        var green: CGFloat  = 0
        var blue: CGFloat = 0
        var alpha: CGFloat  = 0
        color1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        var red2: CGFloat = 0
        var green2: CGFloat  = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat  = 0
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return (Int(red*255) == Int(red2*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue2*255) )
    }
}

extension NewTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == .habit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = NewTrackerTableViewCell(style: .default, reuseIdentifier: NewTrackerTableViewCell.reuseIdentifier)
        cell.name.text = tableNames[indexPath.row]
        
        if indexPath.row == 0 {
            cell.choosedParams.text = choosedCategory?.head
        }
        
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
            let chooseCategoryViewController = ChooseCategoryViewController(trackerCategory: choosedCategory)
            chooseCategoryViewController.modalPresentationStyle = .automatic
            chooseCategoryViewController.delegate = self
            present(chooseCategoryViewController, animated: true)
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
            colorCell.configCell(color: colors[indexPath.row] ?? .blue)
            
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
        checkUnblockedButton()
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
