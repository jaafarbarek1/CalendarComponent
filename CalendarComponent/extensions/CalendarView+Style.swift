//
//  CalendarView+Style.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

extension CalendarView {

    public struct Style {

        public enum CellShapeOptions {
            case round
            case square
        }

        public enum FirstWeekdayOptions: Int {
            case sunday
            case monday
            case tuesday
            case wednesday
            case thursday
            case friday
            case saturday
        }

        //Event
        public static var cellEventColor = UIColor.yellow

        //Header
        public static var headerHeight: CGFloat = 140.0
        public static var headerTextColor = UIColor.charcoalGrey
        public static var headerFont = UIFont(name: "Helvetica", size: 20.0) // Used for the month
        public static var subHeaderFont = UIFont(name: "Helvetica", size: 14.0) // Used for days of the week

        //Common
        public static var cellShape = CellShapeOptions.square
        public static var firstWeekday = FirstWeekdayOptions.saturday

        //Default Style
        public static var cellColorDefault = UIColor(white: 0.0, alpha: 0.1)
        public static var cellTextColorDefault = UIColor.gray
        public static var cellBorderColor = UIColor.clear
        public static var cellBorderWidth = CGFloat(0.0)
        public static var cellFont = UIFont(name: "Helvetica", size: 13.0)

        //Today Style
        public static var cellTextColorToday = UIColor.gray
        public static var cellColorToday = UIColor.blue

        //Selected Style
        public static var cellSelectedBorderColor = UIColor.black
        public static var cellSelectedBorderWidth = CGFloat(1.0)
        public static var cellSelectedColor = UIColor.curiousBlue
        public static var cellSelectedTextColor = UIColor.white

        //Weekend Style
        public static var cellTextColorWeekend = UIColor.black

        //Locale Style
        public static var locale = Locale.current

        //TimeZone Calendar Style
        public static var timeZone = TimeZone.current

        //Calendar Identifier Style
        public static var identifier = Calendar.Identifier.gregorian

        //Hide/Alter Cells Outside Date Range
        public static var hideCellsOutsideDateRange = true
        public static var changeCellColorOutsideRange = true
        public static var cellTextColorOutsideRange = UIColor.lightGreyBlue
    }
}
