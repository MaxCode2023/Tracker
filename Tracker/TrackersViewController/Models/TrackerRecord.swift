//
//  TrackerRecord.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import Foundation

public struct TrackerRecord: Hashable {
    let id: UUID
    let trackerId: UUID
    let date: Date?
}
