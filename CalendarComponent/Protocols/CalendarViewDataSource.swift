//
//  CalendarViewDataSource.swift
//  Matic
//
//  Created by MATIC on 6/26/19.
//  Copyright © 2019 Software Brothers. All rights reserved.
//

import Foundation

public protocol CalendarViewDataSource {
    func startDate() -> Date
    func endDate() -> Date
    /* optional */
    func userSelectedDates() -> [Date]?
    func maximumNumberOfDaysToSelect() -> Int
    func headerString(_ date: Date) -> String?
}

public extension CalendarViewDataSource {
    func userSelectedDates() -> [Date]? {
        return nil
    }

    func headerString(_ date: Date) -> String? {
        return nil
    }
}
