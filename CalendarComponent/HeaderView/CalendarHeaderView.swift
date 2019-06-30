//
//  CalendarHeaderView.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

open class CalendarHeaderView: UIView {

    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Helvetica", size: 17.0)
        label.textColor = UIColor.charcoalGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Date and time"
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "Helvetica", size: 13.0)
        label.textColor = UIColor.blueGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dayLabelContainerView: UIView = {
        let view = UIView()

        let formatter = DateFormatter()
        formatter.locale = CalendarView.Style.locale
        formatter.timeZone = CalendarView.Style.timeZone

        var start = CalendarView.Style.firstWeekday.rawValue

        for index in start ..< (start + 7) {

            let weekdayLabel = UILabel()

            weekdayLabel.font = UIFont(name: "Helvetica", size: 11.0)

            weekdayLabel.text = formatter.shortWeekdaySymbols[(index % 7)].capitalized

            weekdayLabel.textColor = UIColor.blueGrey
            weekdayLabel.textAlignment = NSTextAlignment.center

            view.addSubview(weekdayLabel)
        }

        self.addSubview(view)

        return view

    }()

    lazy var bottomSeparatorView: UIView = {
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = .paleBlue
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        return bottomSeparatorView

    }()

    override open func layoutSubviews() {
        super.layoutSubviews()

        self.addSubview(bottomSeparatorView)
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        bottomSeparatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true

        self.addSubview(monthLabel)
        monthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: self.bottomSeparatorView.topAnchor, constant: -50).isActive = true

        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true

        var frame = self.bounds
        frame.origin.y += 5.0
        frame.size.height = self.bounds.size.height / 2.0 - 5.0

        //self.monthLabel.frame = frame

        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height / 2.0,
            width: self.bounds.size.width / 7.0,
            height: self.bounds.size.height / 2.0
        )

        for lbl in self.dayLabelContainerView.subviews {

            lbl.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
    }
}
