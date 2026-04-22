//
//  ErrorViewController.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

struct ErrorUIModel: Equatable {
    let image: UIImage
    let title: String
    let actionTitle: String
}

protocol ErrorViewModelProtocol: AnyObject {
    var model: ErrorUIModel { get }
    func didSelectAction()
}

// MARK: - UIViewController

class ErrorViewController: UIViewController {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let actionButton = UIButton()
    private let viewModel: ErrorViewModelProtocol
    
    init(viewModel: ErrorViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        constraintSubviews()
        setupSubviews()
        load(viewModel.model)
    }
}

// MARK: - UI Setup

private extension ErrorViewController {
    func addSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
    }
    
    func constraintSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupSubviews() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Spacing.s
        
        actionButton.configuration = .primary
        actionButton.addAction(
            .init { [weak self] _ in self?.viewModel.didSelectAction() },
            for: .touchUpInside
        )
    }
    
    func load(_ model: ErrorUIModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        actionButton.setTitle(model.actionTitle, for: .normal)
    }
}

// MARK: - Preview

#Preview {
    class PreviewErrorViewModel: ErrorViewModelProtocol {
        let model = ErrorUIModel(
            image: UIImage(systemName: "exclamationmark.triangle.fill")!,
            title: "Something went wrong",
            actionTitle: "Retry"
        )
        
        func didSelectAction() {}
    }

    return ErrorViewController(viewModel: PreviewErrorViewModel())
}
