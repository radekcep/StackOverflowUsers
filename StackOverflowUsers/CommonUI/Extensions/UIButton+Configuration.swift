//
//  UIButton+Configuration.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

extension UIButton.Configuration {
    static var primary: Self {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = .init(top: Spacing.xs, leading: Spacing.s, bottom: Spacing.xs, trailing: Spacing.s)
        return configuration
    }
    
    static var secondary: Self {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: Spacing.xs, leading: Spacing.xs, bottom: Spacing.xs, trailing: Spacing.xs)
        return configuration
    }
}
