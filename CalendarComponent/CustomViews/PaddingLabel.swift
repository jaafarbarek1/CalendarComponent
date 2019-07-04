//
//  Label+Padding.swift
//  CalendarComponent
//
//  Created by MATIC on 7/3/19.
//  Copyright © 2019 MATIC. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 1.0
    @IBInspectable var bottomInset: CGFloat = 1.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
