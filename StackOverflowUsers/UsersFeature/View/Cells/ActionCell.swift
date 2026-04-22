//
//  ActionCell.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

struct ActionUIModel: Equatable {
    let title: String
}

// MARK: - UITableViewCell

class ActionCell: UITableViewCell {
    private var actionButton = UIButton()
    
    var onActionClick: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        constraintSubviews()
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(actionButton)
    }
    
    func constraintSubviews() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Spacing.s),
            actionButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.s),
            actionButton.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    func setupSubviews() {
        actionButton.configuration = .primary
        actionButton.addAction(
            .init { [weak self] _ in self?.onActionClick?() },
            for: .touchUpInside
        )
    }
    
    func load(_ model: ActionUIModel) {
        actionButton.setTitle(model.title, for: .normal)
    }
}

// MARK: - Preview

#Preview {
    let model = ActionUIModel(
        title: "Click Me!"
    )
    
    let cell = ActionCell()
    cell.load(model)
    
    return cell
}
