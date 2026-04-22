//
//  CGRect+Spacing.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

extension UIEdgeInsets {
    static var s: Self {
        .init(top: Spacing.s, left: Spacing.s, bottom: Spacing.s, right: Spacing.s)
    }
}
