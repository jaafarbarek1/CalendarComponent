//
//  CalendarViewDelegate.swift
//  Matic
//
//  Created by MATIC on 6/26/19.
//  Copyright © 2019 Software Brothers. All rights reserved.
//

import Foundation

public protocol CalendarViewDelegate: AnyObject {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent])
    /* optional */
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date)
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?)
}

extension CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool { return true }
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) { return }
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) { return }
}
