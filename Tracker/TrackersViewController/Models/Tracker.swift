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

public enum Week {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}
