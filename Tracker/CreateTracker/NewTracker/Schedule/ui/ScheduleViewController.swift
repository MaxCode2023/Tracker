//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by macOS on 15.04.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let confirmButton = UIButton()
    
    private var scheduleList: [ScheduleElement] = []
    private var choosedWeekdays: [Week]?
    
    var delegate: ScheduleViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleList = createCheduleList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        setUi()
    }
    
    init(choosedWeekdays: [Week]? = nil) {
        self.choosedWeekdays = choosedWeekdays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCheduleList() -> [ScheduleElement] {
        if let choosedWeekdays {
            return Week.allCases.map { dayOfWeek in
                ScheduleElement(weekDay: dayOfWeek, isChoosen: choosedWeekdays.contains(where: {$0 == dayOfWeek}))
            }
        } else {
            return Week.allCases.map { ScheduleElement(weekDay: $0, isChoosen: false) }
        }
    }
    
    private func setUi() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        
        view.backgroundColor = UIColor(named: Constants.ColorNames.white)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.allowsSelection = false
        
        confirmButton.backgroundColor = .black
        confirmButton.setTitle("Готово", for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16)
        confirmButton.layer.cornerRadius = 16
        confirmButton.backgroundColor = UIColor(named: Constants.ColorNames.black)
        confirmButton.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        
        titleLabel.text = "Расписание"
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(named: Constants.ColorNames.black)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    @objc private func clickConfirm() {
        let weekList = scheduleList
            .filter { $0.isChoosen }
            .map { $0.weekDay }
        delegate?.didFinishPickingWeekDays(weekDayList: weekList)
        dismiss(animated: true)
    }
    
}

extension ScheduleViewController: ScheduleCellDelegate {
    func didWeekDayIsOnChanged(scheduleElement: ScheduleElement) {
        scheduleList = scheduleList.filter { $0.weekDay != scheduleElement.weekDay }
        scheduleList.append(scheduleElement)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath)
        guard let scheduleListCell = cell as? ScheduleCell else {
            return UITableViewCell()
        }
        
        let scheduleElement = scheduleList[indexPath.row]
        scheduleListCell.delegate = self
        scheduleListCell.configCell(for: scheduleElement)
        return scheduleListCell
    }
    
}
