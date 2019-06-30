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
    func preselectedDates() -> [Date]?
    /* optional */
    func headerString(_ date: Date) -> String?
}

extension CalendarViewDataSource {

    func startDate() -> Date {
        return Date()
    }

    func endDate() -> Date {
        return Date()
    }

    func preselectedDates() -> [Date]? {
        return nil
    }

    func headerString(_ date: Date) -> String? {
        return nil
    }
}
