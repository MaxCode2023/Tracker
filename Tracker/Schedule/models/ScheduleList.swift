//
//  ScheduleList.swift
//  Tracker
//
//  Created by macOS on 15.04.2023.
//

struct ScheduleList {
    let scheduleList: [ScheduleElement]
    
    init() {
        self.scheduleList = [
            ScheduleElement(weekDay: .monday, isChoosen: false),
            ScheduleElement(weekDay: .tuesday, isChoosen: false),
            ScheduleElement(weekDay: .wednesday, isChoosen: false),
            ScheduleElement(weekDay: .thursday, isChoosen: false),
            ScheduleElement(weekDay: .friday, isChoosen: false),
            ScheduleElement(weekDay: .saturday, isChoosen: false),
            ScheduleElement(weekDay: .sunday, isChoosen: false)
        ]
    }
}

struct ScheduleElement {
    let weekDay: WeekDay
    let isChoosen: Bool
}
