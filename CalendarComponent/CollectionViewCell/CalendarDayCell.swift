//
//  CalendarDayCell.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

open class CalendarDayCell: UICollectionViewCell {

    override open var description: String {
        let dayString = self.textLabel.text ?? " "
        return "<DayCell (text:\"\(dayString)\")>"
    }

    var eventsCount = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    var isToday: Bool = false {
        didSet {
            switch isToday {
            case true:
                self.bgView.backgroundColor = CalendarView.Style.cellColorToday
                self.textLabel.textColor = CalendarView.Style.cellTextColorToday
            case false:
                self.bgView.backgroundColor = CalendarView.Style.cellColorDefault
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }

     open var isCellSelected: Bool {
        didSet {
            switch isCellSelected {
            case true:
                self.bgView.layer.borderColor = CalendarView.Style.cellSelectedBorderColor.cgColor
                self.bgView.layer.borderWidth = CalendarView.Style.cellSelectedBorderWidth
                self.bgView.backgroundColor = CalendarView.Style.cellSelectedColor
                self.textLabel.textColor = CalendarView.Style.cellSelectedTextColor
            case false:
                self.bgView.layer.borderColor = CalendarView.Style.cellBorderColor.cgColor
                self.bgView.layer.borderWidth = CalendarView.Style.cellBorderWidth
                self.bgView.backgroundColor = CalendarView.Style.cellColorDefault
            }
        }
    }

    let textLabel = UILabel()
    let bgView = UIView()

    override init(frame: CGRect) {

        self.textLabel.textAlignment = NSTextAlignment.center
        self.textLabel.font = CalendarView.Style.cellFont
        isCellSelected = false

        super.init(frame: frame)

        self.addSubview(self.bgView)
        self.addSubview(self.textLabel)

    }

    required public init?(coder aDecoder: NSCoder) {
        isCellSelected = false
        super.init(coder: aDecoder)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        isUserInteractionEnabled = true
        isSelected = false
        isToday = false
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        let elementsFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)

        self.bgView.frame = elementsFrame
        self.textLabel.frame = elementsFrame

        switch CalendarView.Style.cellShape {
        case .square:
            self.bgView.layer.cornerRadius = 0.0
        case .round:
            self.bgView.layer.cornerRadius = elementsFrame.width * 0.5
        }
    }
}
