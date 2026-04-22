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
    let reputation: String
    let isFollowed: Bool
}

// MARK: - UITableViewCell

class UserCell: UITableViewCell {
    private var mainStackView = UIStackView()
    private var titleStackView = UIStackView()
    private let userImageView = UIImageView()
    private let titleLabel = UILabel()
    private let reputationLabel = UILabel()
    private let followButton = UIButton()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        titleLabel.text = nil
        reputationLabel.text = nil
        followButton.setTitle(nil, for: .normal)
    }
    
    func addSubviews() {
        contentView.addSubview(mainStackView)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(reputationLabel)
        
        mainStackView.addArrangedSubview(userImageView)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(followButton)
    }
    
    func constraintSubviews() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: Spacing.xl),
            userImageView.widthAnchor.constraint(equalToConstant: Spacing.xl),
        ])
    }
    
    func setupSubviews() {
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.spacing = Spacing.s
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .s
        
        titleStackView.axis = .vertical
        titleStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        userImageView.layer.cornerRadius = Spacing.xl / 2
        userImageView.clipsToBounds = true
        
        followButton.addAction(
            .init { [weak self] _ in self?.onFollowClick?() },
            for: .touchUpInside
        )
        followButton.setContentHuggingPriority(.required, for: .horizontal)
        followButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
    }
    
    func load(_ model: UserUIModel) {
        titleLabel.text = model.name
        reputationLabel.text = model.reputation
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
        reputation: "12345",
        isFollowed: true
    )
    
    let cell = UserCell()
    cell.load(model)
    
    return cell
}
