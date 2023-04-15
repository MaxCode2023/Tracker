//
//  ScheduleCell.swift
//  Tracker
//
//  Created by macOS on 15.04.2023.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    
    static let reuseIdentifier = "scheduleCell"
    
    private let weekDayLabel = UILabel()
    private let weekDaySwitch = UISwitch()
    
    func configCell(for element: ScheduleElement) {
        backgroundColor = UIColor(named: "background view")?.withAlphaComponent(0.3)
        
        addSubview(weekDayLabel)
        addSubview(weekDaySwitch)
        weekDayLabel.text = element.weekDay.rawValue
        weekDayLabel.font = .systemFont(ofSize: 17)
        weekDayLabel.textColor = UIColor(named: "black")
        weekDaySwitch.isOn = element.isChoosen
        
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            weekDayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weekDayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            weekDaySwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            weekDaySwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
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
    
}
