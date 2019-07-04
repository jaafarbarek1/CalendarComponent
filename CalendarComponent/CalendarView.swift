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
    public let itemsCount = 14 // rows:7 x cols:2

    var headerView: CalendarHeaderView!
    public var collectionView: UICollectionView!

    public lazy var calendar: Calendar = {
        var calendarStyle = Calendar(identifier: CalendarView.Style.identifier)
        calendarStyle.timeZone = CalendarView.Style.timeZone
        return calendarStyle
    }()

    var startDateCache = Date()
    var endDateCache = Date()
    var startOfMonthCache = Date()
    var endOfMonthCache = Date()
    var preselectedDates = [Date]() {
        didSet {
            selectedIndexPaths = []
            selectedDates = []
            selectDates(preselectedDates)
        }
    }
    var maximumNumberOfDaysToSelect = 0 {
        didSet {
            headerView.maximumNumberOfDaysToSelect = maximumNumberOfDaysToSelect
        }
    }
    var max = [Date]()

    var todayIndexPath: IndexPath?

    var selectedIndexPaths = [IndexPath]()
    var selectedDates = [Date]()

    var monthInfoForSection = [Int: (firstDay: Int, daysTotal: Int)]()
    var eventsByIndexPath = [IndexPath: [CalendarEvent]]()

    public var events: [CalendarEvent] = []
//    {
//        didSet {
//            self.eventsByIndexPath.removeAll()
//
//            for event in events {
//                guard let indexPath = self.indexPathForDate(event.startDate) else { continue }
//
//                var eventsForIndexPath = eventsByIndexPath[indexPath] ?? []
//                eventsForIndexPath.append(event)
//                eventsByIndexPath[indexPath] = eventsForIndexPath
//            }
//
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }

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

        // Header View
        self.headerView = CalendarHeaderView(frame: .zero)
        self.addSubview(self.headerView)

        // Layout
        let layout = CalendarFlowLayout()
        layout.scrollDirection = self.direction
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.cellSize(in: self.bounds)

        // Collection View
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.semanticContentAttribute = .forceLeftToRight // forces western style language orientation
        addSubview(self.collectionView)

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

        headerView.preselectedDates = preselectedDates
        headerView.maximumNumberOfDaysToSelect = maximumNumberOfDaysToSelect
        selectedDates = preselectedDates
        self.resetDisplayDate()
    }

    private func cellSize(in bounds: CGRect) -> CGSize {
        return CGSize(
            width: frame.size.width / 7.0, // number of days in week
            height: frame.size.width / 7.0
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

// MARK: - Public methods
extension CalendarView {

    public func reloadData() {
        headerView.preselectedDates = preselectedDates
        headerView.maximumNumberOfDaysToSelect = maximumNumberOfDaysToSelect
        selectedDates = preselectedDates
        self.collectionView.reloadData()
    }

    public func setDisplayDate(_ date: Date, animated: Bool = false) {

        guard (date >= startDateCache) && (date <= endDateCache) else { return }
        self.collectionView.setContentOffset(self.scrollViewOffset(for: date), animated: animated)
        self.displayDateOnHeader(date)
    }

    public func selectDates(_ dates: [Date]) {
        for date in dates {
            guard let indexPath = self.indexPathForDate(date) else { return }
            selectedDates.append(date)
            selectedIndexPaths.append(indexPath)
        }
        headerView.preselectedDates = dates
//        self.collectionView.selectItem(at: indexPath, animated: false,
//                                       scrollPosition: UICollectionView.ScrollPosition())
//        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    public func deselectDate(_ date: Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        self.collectionView.deselectItem(at: indexPath, animated: false)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
