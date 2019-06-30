//
//  CalendarView.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

public class CalendarView: UIView {

    public let cellReuseIdentifier = "CalendarDayCell"
    public let itemsCount = 42 // rows:7 x cols:2

    var headerView: CalendarHeaderView!
    var collectionView: UICollectionView!

    public lazy var calendar: Calendar = {
        var calendarStyle = Calendar(identifier: CalendarView.Style.identifier)
        calendarStyle.timeZone = CalendarView.Style.timeZone
        return calendarStyle
    }()

    var startDateCache = Date()
    var endDateCache = Date()
    var startOfMonthCache = Date()
    var endOfMonthCache = Date()

    var todayIndexPath: IndexPath?
//    {
//        didSet {
//            if let idx = todayIndexPath {
//                print("today is in: \(idx.row) row & section: \(idx.section) & item: \(idx.item)")
//                let positionInColumn = idx.item % 7
//                print("today's position in columns is: \(positionInColumn)")
//
//                //self.collectionView.scrollToItem(at: idx, at: UICollectionView.ScrollPosition.left, animated: true)
//                if let date = dateFromIndexPath(idx) {
//                    let weeks = Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth!
//                    self.goToCurrentDateWeek(weeks)
//                }
//            }
//        }
//    }

    var selectedIndexPaths = [IndexPath]()
    var selectedDates = [Date]()

    var monthInfoForSection = [Int: (firstDay: Int, daysTotal: Int)]()
    var eventsByIndexPath = [IndexPath: [CalendarEvent]]()

    public var events: [CalendarEvent] = [] {
        didSet {
            self.eventsByIndexPath.removeAll()

            for event in events {
                guard let indexPath = self.indexPathForDate(event.startDate) else { continue }

                var eventsForIndexPath = eventsByIndexPath[indexPath] ?? []
                eventsForIndexPath.append(event)
                eventsByIndexPath[indexPath] = eventsForIndexPath
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    var flowLayout: CalendarFlowLayout {
        // swiftlint:disable force_cast
        let layout = self.collectionView.collectionViewLayout as! CalendarFlowLayout
        return layout
    }

    // MARK: - public

    public var displayDate: Date?
    public var multipleSelectionEnable = true
    public var enableDeslection = true

    public weak var delegate: CalendarViewDelegate?
    public var dataSource: CalendarViewDataSource?

    public var direction: UICollectionView.ScrollDirection = .vertical {
        didSet {
            flowLayout.scrollDirection = direction
            self.collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    // MARK: Create Subviews
    private func setup() {

        self.clipsToBounds = true

        /* Header View */
        self.headerView = CalendarHeaderView(frame: CGRect.zero)
        self.addSubview(self.headerView)

        /* Layout */
        let layout = CalendarFlowLayout()
        layout.scrollDirection = self.direction
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.cellSize(in: self.bounds)

        /* Collection View */
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView.semanticContentAttribute = .forceLeftToRight // forces western style language orientation
        self.addSubview(self.collectionView)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CalendarView.handleLongPress))
        self.collectionView.addGestureRecognizer(longPress)
    }

    @objc
     func handleLongPress(gesture: UILongPressGestureRecognizer) {

        guard gesture.state == UIGestureRecognizer.State.began else {
        return
        }

        let point = gesture.location(in: collectionView)

        guard
            let indexPath = collectionView.indexPathForItem(at: point),
            let date = self.dateFromIndexPath(indexPath) else {
                return
        }

        guard
            let indexPathEvents = collectionView.indexPathForItem(at: point),
            let events = self.eventsByIndexPath[indexPathEvents], !events.isEmpty else {
                self.delegate?.calendar(self, didLongPressDate: date, withEvents: nil)
                return
        }

        self.delegate?.calendar(self, didLongPressDate: date, withEvents: events)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        self.headerView.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: self.frame.size.width,
            height: CalendarView.Style.headerHeight
        )

        self.collectionView.frame = CGRect(
            x: 0.0,
            y: CalendarView.Style.headerHeight,
            width: self.frame.size.width,
            height: self.frame.size.height - CalendarView.Style.headerHeight
        )

        flowLayout.itemSize = self.cellSize(in: self.bounds)

        self.resetDisplayDate()
    }

    private func cellSize(in bounds: CGRect) -> CGSize {
        let width = 50 // frame.size.width / 7.0
        return CGSize(
            width: width, // number of days in week
            height: width // maximum number of rows
        )
    }

    func resetDisplayDate() {
        guard let displayDate = self.displayDate else { return }

        self.collectionView.setContentOffset(
            self.scrollViewOffset(for: displayDate),
            animated: false
        )
    }

    func scrollViewOffset(for date: Date) -> CGPoint {
        var point = CGPoint.zero

        guard let sections = self.indexPathForDate(date)?.section else { return point }

        switch self.direction {
        case .horizontal:
            point.x = CGFloat(sections) * self.collectionView.frame.size.width
        case .vertical:
            point.y = CGFloat(sections) * self.collectionView.frame.size.height
        }

        return point
    }
//    func scrollViewOffsetToCurrentDate(for date: Date) -> CGPoint {
//        var point = CGPoint.zero
//
//        guard let sections = self.indexPathForDate(date)?.section else { return point }
//
//        switch self.direction {
//        case .horizontal:
//            point.x = CGFloat(sections) * self.collectionView.frame.size.width
//        case .vertical:
//            let weeks: Double = Double(Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth!)
//            print(self.collectionView.frame.size.height)
//            var constant = 0.0
//            switch weeks {
//            case 1:
//                constant = 0.0
//            case 2:
//                constant = 0.0
//            case 3:
//                constant = 2.9
//            case 4:
//                constant = 4.6
//            case 5:
//                constant = 2.6
//            case 6:
//                constant = 5.6
//            default:
//                constant = weeks
//            }
//            let offset: CGFloat = (CGFloat((constant) * (110 / 6))) / 100.0
//            point.y = offset * self.collectionView.frame.size.height
//
//        }
//        return point
//    }
}

// MARK: Convertion

extension CalendarView {

    func indexPathForDate(_ date: Date) -> IndexPath? {

        let distanceFromStartDate = self.calendar.dateComponents([.month, .day], from: self.startOfMonthCache, to: date)
        guard
            let day = distanceFromStartDate.day,
            let month = distanceFromStartDate.month,
            let (firstDayIndex, _) = monthInfoForSection[month] else { return nil }

        return IndexPath(item: day + firstDayIndex, section: month)
    }

    func dateFromIndexPath(_ indexPath: IndexPath) -> Date? {

        let month = indexPath.section

        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = month

        guard
            let correctMonthForSectionDate = self.calendar.date(byAdding: monthOffsetComponents, to: startOfMonthCache),
            let info = self.getMonthInfo(for: correctMonthForSectionDate) else { return nil }

        self.monthInfoForSection[month] = info

        guard let monthInfo = monthInfoForSection[month] else {
            return nil
        }

        var components = DateComponents()
        components.month = month
        components.day = indexPath.item - monthInfo.firstDay

        return self.calendar.date(byAdding: components, to: self.startOfMonthCache)
    }

    func textFromIndexPath(_ indexPath: IndexPath) -> String {

        let month = indexPath.section

        guard let monthInfo = monthInfoForSection[month] else { return "" }

        var components = DateComponents()
        components.month = month
        let day = indexPath.item - monthInfo.firstDay

        return "\(day)"
    }
}

extension CalendarView {

//    func goToCurrentDateWeek(_ offset: Int) {
//
//        guard let displayDate = self.displayDate else {
//            return
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.collectionView.setContentOffset(self.scrollViewOffsetToCurrentDate(for: displayDate), animated: true)
//        }
//
//    }
}

// MARK: - Public methods
extension CalendarView {

    /*
     method: - reloadData
     function: - reload all components in collection view
     */
    public func reloadData() {
        self.collectionView.reloadData()
    }

    /*
     method: - setDisplayDate
     params:
     - date: Date to extract month and year to scroll at correct section;
     - animated: to handle animation if want;
     function: - scroll calendar at date (month/year) passed as parameter.
     */
    public func setDisplayDate(_ date: Date, animated: Bool = false) {

        guard (date >= startDateCache) && (date <= endDateCache) else { return }
        self.collectionView.setContentOffset(self.scrollViewOffset(for: date), animated: animated)
        self.displayDateOnHeader(date)
    }

    /*
     method: - selectDate
     params:
     - date: Date to select
     function: - mark date as selected and add it to the array of selected dates
     */
    public func selectDate(_ date: Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }

        self.collectionView.selectItem(at: indexPath, animated: false,
                                       scrollPosition: UICollectionView.ScrollPosition())
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    /*
     method: - deselectDate
     params:
     - date: Date to deselect
     function: - unmark date as selected and remove it from the array of selected dates
     */
    public func deselectDate(_ date: Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        self.collectionView.deselectItem(at: indexPath, animated: false)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
