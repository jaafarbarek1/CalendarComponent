//
//  MainViewController.swift
//  Matic
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 Software Brothers. All rights reserved.
//

import UIKit
import CalendarComponent

class ExampleViewController: UIViewController {

    @IBOutlet private weak var calendarView: CalendarView!
    @IBOutlet private weak var selectedDateLabel: UILabel!

    let today = Date()

    override func viewDidLoad() {

        super.viewDidLoad()

        CalendarView.Style.cellShape = .square
        CalendarView.Style.cellColorDefault = UIColor.clear
        CalendarView.Style.cellSelectedBorderColor = UIColor.curiousBlue
        CalendarView.Style.headerTextColor = UIColor.white
        CalendarView.Style.cellTextColorDefault = UIColor.charcoalGrey
        CalendarView.Style.cellTextColorToday = UIColor.charcoalGrey
        CalendarView.Style.cellSelectedTextColor = UIColor.white

        CalendarView.Style.firstWeekday = .saturday

        CalendarView.Style.locale = Locale(identifier: "en_US")

        CalendarView.Style.timeZone = TimeZone(abbreviation: "UTC")!

        CalendarView.Style.hideCellsOutsideDateRange = false
        CalendarView.Style.changeCellColorOutsideRange = false

        CalendarView.Style.cellFont = UIFont(name: "Helvetica", size: 13.0)
        CalendarView.Style.headerFont = UIFont(name: "Helvetica", size: 20.0)
        CalendarView.Style.subHeaderFont = UIFont(name: "Helvetica", size: 14.0)


        calendarView.dataSource = self
        calendarView.delegate = self

        //calendarView?.collectionView.isScrollEnabled = false
        calendarView.multipleSelectionEnable = false

        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 6.0

        configureConstants()
    }

    func configureConstants() {
        CalendarView.Constants.checkmarkImage = UIImage(named: "checkmark")!
        CalendarView.Constants.checkmarkImageViewBackgroundColor = .turquois
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.setDisplayDate(Date(), animated: true)
    }

    var maximumNumberOfDays = 0
    var selectedDates = [Date]()
    var allowedDates = [Date]()

    private func populateCalendar(maximumNumberOfDays: Int,selectedDates: [Date] ) {
        self.selectedDates = selectedDates
        self.maximumNumberOfDays = maximumNumberOfDays
        calendarView.reloadData()
    }

    @IBAction func onResetPressed(_ sender: UIButton) {
        populateCalendar(maximumNumberOfDays: 0, selectedDates: [])

    }
    @IBAction func onWeeklyVisitsPressed(_ sender: UIButton) {
//        var dateComponents = DateComponents()
//
//        let today = Date()
//        dateComponents.day = 7
//        let oneWeekAfter = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
//
//        populateCalendar(maximumNumberOfDays: 2, selectedDates: [today, oneWeekAfter])

    }
    @IBAction func onPackagesWithRandomNumberSelected(_ sender: UIButton) {
        var dateComponents = DateComponents()
        var dates = [Date]()

        let days = [1,2,3,4,5,6,7]
        let randoms = days[randomPick: 7]

        for i in 0..<3 {


            dateComponents.day = randoms[i]

            let randomDate = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
            dates.append(randomDate)
        }

        populateCalendar(maximumNumberOfDays: 5, selectedDates: dates)

    }
    @IBAction func onPackageWithAllDateSelected(_ sender: UIButton) {
        var dateComponents = DateComponents()
        var dates = [Date]()

        let days = [1,2,3,4,5,6,7]
        let randoms = days[randomPick: 7]

        for i in 0..<5 {


            dateComponents.day = randoms[i]

            let randomDate = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
            dates.append(randomDate)
        }

        populateCalendar(maximumNumberOfDays: 5, selectedDates: dates)
    }
    

}

// MARK: CalendarDataSource
extension ExampleViewController: CalendarViewDataSource {

    func maximumNumberOfDaysToSelect() -> Int {
        return maximumNumberOfDays
    }


    func startDate() -> Date {
        return today
    }

    func endDate() -> Date {

        var dateComponents = DateComponents()

        dateComponents.day = 7

        let oneWeekFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

        return oneWeekFromNow
    }

    func userSelectedDates() -> [Date]? {
        return selectedDates
    }

    func headerString(_ date: Date) -> String? {
        let month = calendarView.calendar.component(.month, from: date) // get month

        let formatter = DateFormatter()
        formatter.locale = CalendarView.Style.locale
        formatter.timeZone = CalendarView.Style.timeZone

        let monthName = formatter.monthSymbols[(month - 1) % 12].localizedCapitalized

        return monthName
    }
}

// MARK: Calendar Delegate
extension ExampleViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        self.selectedDateLabel.text = "\(date)"
    }

    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        print("Long Pressed at date: \(date)")
    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
        //return !compareDate(date1: date, date2: Date())
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
extension Array {
    /// Picks `n` random elements (straightforward approach)
    subscript (randomPick n: Int) -> [Element] {
        var indices = [Int](0..<count)
        var randoms = [Int]()
        for _ in 0..<n {
            randoms.append(indices.remove(at: Int(arc4random_uniform(UInt32(indices.count)))))
        }
        return randoms.map { self[$0] }
    }
}
