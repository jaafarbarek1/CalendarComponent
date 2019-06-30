//
//  CalendarEvent.swift
//  Matic
//
//  Created by MATIC on 6/26/19.
//  Copyright © 2019 Software Brothers. All rights reserved.
//

import Foundation

public struct CalendarEvent {
    public let title: String
    public let startDate: Date
    public let endDate: Date?

    public init(title: String, startDate: Date, endDate: Date?) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
