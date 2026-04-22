//
//  UserCell.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

struct UserUIModel: Equatable {
    let name: String
    let image: UIImage
    let isFollowed: Bool
}

// MARK: - UITableViewCell

class UserCell: UITableViewCell {
    private var stackView = UIStackView()
    private let userImageView = UIImageView()
    private var titleLabel = UILabel()
    private var followButton = UIButton()
    
    var onFollowClick: (() -> Void)?
    
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(userImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(followButton)
    }
    
    func constraintSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: Spacing.xl),
            userImageView.widthAnchor.constraint(equalToConstant: Spacing.xl),
        ])
    }
    
    func setupSubviews() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Spacing.s
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .s
        
        userImageView.layer.cornerRadius = Spacing.xl / 2
        userImageView.clipsToBounds = true
        
        followButton.addAction(
            .init { [weak self] _ in self?.onFollowClick?() },
            for: .touchUpInside
        )
    }
    
    func load(_ model: UserUIModel) {
        titleLabel.text = model.name
        userImageView.image = model.image
        
        if model.isFollowed {
            followButton.configuration = .primary
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.configuration = .secondary
            followButton.setTitle("Follow", for: .normal)
        }
    }
}

// MARK: - Preview

#Preview {
    let model = UserUIModel(
        name: "Ferda Mravenec",
        image: UIImage(systemName: "person.circle")!,
        isFollowed: true
    )
    
    let cell = UserCell()
    cell.load(model)
    
    return cell
}
