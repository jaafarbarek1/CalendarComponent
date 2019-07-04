//
//  CalendarComponent+datasource.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

extension CalendarView: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {

        guard let dateSource = self.dataSource else { return 0 }

        self.startDateCache = dateSource.startDate()
        self.endDateCache = dateSource.endDate()
        self.preselectedDates = dateSource.userSelectedDates() ?? []
        print(dateSource.maximumNumberOfDaysToSelect())
        self.maximumNumberOfDaysToSelect = dateSource.maximumNumberOfDaysToSelect()

        guard self.startDateCache <= self.endDateCache else { fatalError("Start date cannot be later than end date.") }

        var firstDayOfStartMonthComponents = self.calendar.dateComponents([.era, .year, .month],
                                                                          from: self.startDateCache)
        firstDayOfStartMonthComponents.day = 1

        let firstDayOfStartMonthDate = self.calendar.date(from: firstDayOfStartMonthComponents)!

        self.startOfMonthCache = firstDayOfStartMonthDate

        var lastDayOfEndMonthComponents = self.calendar.dateComponents([.era, .year, .month], from: self.endDateCache)
        let range = self.calendar.range(of: .day, in: .month, for: self.endDateCache)!
        lastDayOfEndMonthComponents.day = range.count

        self.endOfMonthCache = self.calendar.date(from: lastDayOfEndMonthComponents)!

        let today = Date()

        if (self.startOfMonthCache ... self.endOfMonthCache).contains(today) {

            let distanceFromTodayComponents = self.calendar.dateComponents([.month, .day],
                                                                           from: self.startOfMonthCache, to: today)

            self.todayIndexPath = IndexPath(item: distanceFromTodayComponents.day!,
                                            section: distanceFromTodayComponents.month!)

        }

        // if we are for example on the same month and the difference is 0 we still need 1 to display it
        return self.calendar.dateComponents([.month], from: startOfMonthCache, to: endOfMonthCache).month! + 1
    }

    public func getMonthInfo(for date: Date) -> (firstDay: Int, daysTotal: Int)? {

        var firstWeekdayOfMonthIndex = self.calendar.component(.weekday, from: date)
        firstWeekdayOfMonthIndex -= CalendarView.Style.firstWeekday.rawValue
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7

        guard let rangeOfDaysInMonth = self.calendar.range(of: .day, in: .month, for: date) else { return nil }

        return (firstDay: firstWeekdayOfMonthIndex, daysTotal: rangeOfDaysInMonth.count)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = section

        guard
            let correctMonthForSectionDate = self.calendar.date(byAdding: monthOffsetComponents, to: startOfMonthCache),
            let info = self.getMonthInfo(for: correctMonthForSectionDate) else {
                return 0
        }

        self.monthInfoForSection[section] = info

        return itemsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {

            guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier,
                                                                   for: indexPath) as? CalendarDayCell else {
                                                                    return UICollectionViewCell()
            }

            guard let (firstDayIndex, _) = self.monthInfoForSection[indexPath.section] else {
                return dayCell
            }

            if let date = dateFromIndexPath(indexPath) {

                if let day = date.dayNumberFromDate() {
                    dayCell.textLabel.text = "\(day)"

                }
                for preselectedDate in preselectedDates {
                    print(preselectedDate)
                }
            }

            print(selectedIndexPaths.count)
            dayCell.isCellSelected = selectedIndexPaths.contains(indexPath)

            hideOrAlterCellsOutsideDates(indexPath: indexPath,
                                         firstDayIndex: firstDayIndex,
                                         lastDayIndex: itemsCount,
                                         dayCell: dayCell)

            return dayCell
    }

    func compareDate(date1: Date, date2: Date) -> Bool {
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}

extension CalendarView {

    func hideOrAlterCellsOutsideDates(indexPath: IndexPath,
                                      firstDayIndex: Int,
                                      lastDayIndex: Int,
                                      dayCell: CalendarDayCell) {
        if indexPath.section == 0 {
            let startDay = Calendar.current.component(.day, from: startDateCache) - 1
            let daysToShow = startDay + firstDayIndex
            let lastDay = daysToShow + 8
            if !(daysToShow..<lastDay).contains(indexPath.item) {
                hideOrAlterCells(cell: dayCell)
            }
        }
    }

    func hideOrAlterCells(cell: CalendarDayCell) {
        cell.textLabel.textColor = CalendarView.Style.cellTextColorOutsideRange
        cell.isUserInteractionEnabled = false
    }
}

extension Date {
    func dayNumberFromDate() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
}
