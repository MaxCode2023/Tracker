//
//  ScheduleCell.swift
//  Tracker
//
//  Created by macOS on 15.04.2023.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    
    static let reuseIdentifier = "scheduleCell"
    var delegate: ScheduleCellDelegate? = nil
    
    private var scheduleElement: ScheduleElement? = nil
    
    private let weekDayLabel = UILabel()
    private let weekDaySwitch = UISwitch()
    
    func configCell(for element: ScheduleElement) {
        scheduleElement = element
        backgroundColor = UIColor(named: "background view")?.withAlphaComponent(0.3)
        
        contentView.addSubview(weekDayLabel)
        contentView.addSubview(weekDaySwitch)
        weekDayLabel.text = element.weekDay.getName()
        weekDayLabel.font = .systemFont(ofSize: 17)
        weekDayLabel.textColor = UIColor(named: "black")
        weekDaySwitch.isOn = element.isChoosen
        weekDaySwitch.onTintColor = UIColor(named: "blue")
        weekDaySwitch.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
        weekDaySwitch.isEnabled = true
        
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            weekDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weekDayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weekDaySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            weekDaySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        if element.weekDay == .monday {
            layer.masksToBounds = true
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if element.weekDay == .sunday {
            layer.masksToBounds = true
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    @objc private func switchStateDidChange(_ sender:UISwitch!) {
        scheduleElement?.isChoosen = sender.isOn
        guard let scheduleElement = scheduleElement else { return }
        delegate?.didWeekDayIsOnChanged(scheduleElement: scheduleElement)
    }
    
}
