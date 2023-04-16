//
//  TrackerModel.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import UIKit

public struct Tracker {
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Week]
}

public enum Week: Int {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
//=======
//public enum Week: String {
//    case monday = "Понедельник"
//    case tuesday = "Вторник"
//    case wednesday = "Среда"
//    case thursday = "Четверг"
//    case friday = "Пятница"
//    case saturday = "Суббота"
//    case sunday = "Воскресенье"
//>>>>>>> sprint_14_schedule
}
