//
//  CalendarComponent+extensions.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import Foundation

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }
}
