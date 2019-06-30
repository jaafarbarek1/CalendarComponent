//
//  CalendarComponent+delegae.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

extension CalendarView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let date = self.dateFromIndexPath(indexPath) else { return }

        if let index = selectedIndexPaths.index(of: indexPath) {

            delegate?.calendar(self, didDeselectDate: date)
            if enableDeslection {
                selectedIndexPaths.remove(at: index)
                selectedDates.remove(at: index)
            }

        } else {

            if !multipleSelectionEnable {
                selectedIndexPaths.removeAll()
                selectedDates.removeAll()
            }

            selectedIndexPaths.append(indexPath)
            selectedDates.append(date)

            let eventsForDaySelected = eventsByIndexPath[indexPath] ?? []
            delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
        }

        self.reloadData()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        guard let dateBeingSelected = self.dateFromIndexPath(indexPath) else { return false }

        if let delegate = self.delegate {
            return delegate.calendar(self, canSelectDate: dateBeingSelected)
        }

        return true // default
    }

    func displayDateOnHeader(_ date: Date) {
        let month = self.calendar.component(.month, from: date) // get month

        let formatter = DateFormatter()
        formatter.locale = CalendarView.Style.locale
        formatter.timeZone = CalendarView.Style.timeZone

        let monthName = formatter.monthSymbols[(month - 1) % 12].capitalized // 0 indexed array

        //let year = self.calendar.component(.year, from: date)

        self.headerView.monthLabel.text = dataSource?.headerString(date) ?? monthName
            //+ " " + String(year)

        self.displayDate = date
    }
}
