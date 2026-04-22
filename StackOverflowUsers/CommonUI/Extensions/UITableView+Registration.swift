//
//  UITableView+Registration.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

private extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableView {
    func register<Cell: UITableViewCell>(_ cell: Cell.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
}
