//
//  CalendarComponent+extensions.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit
//import EventKit

//extension EKEvent {
//    var isOneDay : Bool {
//        let components = Calendar.current.dateComponents([.era, .year, .month, .day],
//                                                         from: self.startDate, to: self.endDate)
//        return (components.era == 0 && components.year == 0 && components.month == 0 && components.day == 0)
//    }
//}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }
}
