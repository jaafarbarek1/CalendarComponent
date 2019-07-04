//
//  CalendarHeaderView.swift
//  CalendarComponent
//
//  Created by MATIC on 6/25/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

open class CalendarHeaderView: UIView {

    var maximumNumberOfDaysToSelect: Int = 0 {
        didSet {
            configureUI()
        }

    }
    var preselectedDates = [Date]()
//    {
//        didSet {
//            configureUI()
//        }
//    }
    func configureUI(){
        if maximumNumberOfDaysToSelect == 0 {
            checkmarkView.isHidden = true
            daysLeftLabel.isHidden = true
        }else {
            if maximumNumberOfDaysToSelect == preselectedDates.count  {
                checkmarkView.isHidden = false
                daysLeftLabel.isHidden = true
            }else {
                checkmarkView.isHidden = true
                daysLeftLabel.isHidden = false
                daysLeftLabel.text = "\(maximumNumberOfDaysToSelect - preselectedDates.count) days left to choose"
            }
        }
    }

    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 17.0)
        label.textColor = .charcoalGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Date and time"
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "Helvetica", size: 13.0)
        label.textColor = .blueGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var daysLeftLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "1 day left to choose"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 13.0)
        label.textColor = .white
        label.backgroundColor = .gray
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
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

            weekdayLabel.textColor = .blueGrey
            weekdayLabel.textAlignment = .center

            view.addSubview(weekdayLabel)
        }

        self.addSubview(view)

        return view

    }()

    lazy var checkmarkImageView: UIImageView = {
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = CalendarView.Constants.checkmarkImage
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.contentMode = .scaleAspectFit
        return checkmarkImageView

    }()

    lazy var checkmarkView: UIView = {
        let checkmarkView = UIView()
        checkmarkView.backgroundColor = CalendarView.Constants.checkmarkImageViewBackgroundColor
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.layer.cornerRadius = 10
        checkmarkView.clipsToBounds = true
        return checkmarkView

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

        self.addSubview(daysLeftLabel)
        daysLeftLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        daysLeftLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 19).isActive = true
        daysLeftLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //        daysLeftLabel.isHidden = true

        self.addSubview(checkmarkView)
        checkmarkView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        checkmarkView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        checkmarkView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkmarkView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //        checkmarkView.isHidden = true

        checkmarkView.addSubview(checkmarkImageView)
        checkmarkImageView.centerXAnchor.constraint(equalTo: checkmarkView.centerXAnchor).isActive = true
        checkmarkImageView.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor).isActive = true
        checkmarkImageView.heightAnchor.constraint(equalToConstant: 9).isActive = true
        checkmarkImageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        //        checkmarkImageView.isHidden = false

        //        if maximumNumberOfDaysToSelect == 0 {
        //            checkmarkView.isHidden = true
        //            daysLeftLabel.isHidden = true
        //        }else {
        //            if maximumNumberOfDaysToSelect == preselectedDates.count  {
        //                checkmarkView.isHidden = false
        //                daysLeftLabel.isHidden = true
        //            }else {
        //                checkmarkView.isHidden = true
        //                daysLeftLabel.isHidden = false
        //                daysLeftLabel.text = "\(maximumNumberOfDaysToSelect - preselectedDates.count) days left to choose"
        //            }
        //        }

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

        for label in self.dayLabelContainerView.subviews {
            label.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
    }
}
