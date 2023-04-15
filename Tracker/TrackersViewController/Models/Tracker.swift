//
//  TrackerModel.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import UIKit

public struct Tracker {
    let id: Int
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Week]
}

public enum Week: String {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}
